"""Watcher DAGs for the XCom backup benchmark.

Each producer fails after its dbt build (an on-run-end hook baked into the image) and retries once, so every run
exercises the task store backup on the first try and the restore on the second. The timings of both tries are
stored in an Airflow Variable per try, which post-process/report-backup-metrics.sh collects.
"""

import json
import os
import re
import time
from datetime import datetime, timedelta
from pathlib import Path

import cosmos.operators._watcher.xcom as xcom
from airflow.sdk import Variable, get_parsing_context
from cosmos import DbtDag, ExecutionConfig, ProfileConfig, ProjectConfig, RenderConfig
from cosmos.constants import ExecutionMode, LoadMode
from cosmos.log import get_logger

AIRFLOW_HOME = Path(__file__).parent.parent
PROJECTS = {
    "bench_fhir_watcher": (AIRFLOW_HOME, "fhir_dbt_analytics"),
    "bench_generated_watcher": (AIRFLOW_HOME / "altered_jaffle_shop", "altered_jaffle_shop"),
}
ROW_BYTES_OVERRIDE = os.environ.get("COSMOS_BENCH_ROW_BYTES")
logger = get_logger("cosmos.bench")
current_dag_id = get_parsing_context().dag_id


def variable_key(dag_id, run_id, try_number):
    return re.sub(r"[^A-Za-z0-9_]", "_", f"bench_{dag_id}_{run_id}_try{try_number}")


def instrument_producer(producer):
    original_execute = producer.execute

    def execute(context, **kwargs):
        if ROW_BYTES_OVERRIDE:
            xcom.MAX_BACKUP_ROW_BYTES = int(ROW_BYTES_OVERRIDE)
        timers = {"persist_s": 0.0, "persist_calls": 0, "restore_read_s": 0.0, "restore_rows": 0, "delete_s": 0.0, "delete_rows": 0}
        original_persist, original_read, original_delete = xcom._persist_backup_row, xcom._read_task_state_store_rows, xcom._delete_task_state_store_rows

        def timed_persist(ti, key, value):
            started = time.perf_counter()
            original_persist(ti, key, value)
            timers["persist_s"] += time.perf_counter() - started
            timers["persist_calls"] += 1

        def timed_read(store):
            started = time.perf_counter()
            entries, rows = original_read(store)
            timers["restore_read_s"] += time.perf_counter() - started
            timers["restore_rows"] += rows
            return entries, rows

        def timed_delete(store, count):
            started = time.perf_counter()
            original_delete(store, count)
            timers["delete_s"] += time.perf_counter() - started
            timers["delete_rows"] += count

        xcom._persist_backup_row, xcom._read_task_state_store_rows, xcom._delete_task_state_store_rows = timed_persist, timed_read, timed_delete
        started = time.perf_counter()
        try:
            return original_execute(context, **kwargs)
        finally:
            timers["execute_s"] = round(time.perf_counter() - started, 2)
            timers["row_bytes"] = xcom.MAX_BACKUP_ROW_BYTES
            ti = context["ti"]
            logger.info("BENCH %s", json.dumps(timers))
            try:
                Variable.set(variable_key(ti.dag_id, context["run_id"], ti.try_number), json.dumps(timers))
            except Exception as error:  # noqa: BLE001
                logger.warning("BENCH could not store the timers in a Variable: %s", error)

    producer.execute = execute


for dag_id, (project_dir, profile_name) in PROJECTS.items():
    if current_dag_id is not None and current_dag_id != dag_id:
        continue
    dag = DbtDag(
        dag_id=dag_id,
        project_config=ProjectConfig(dbt_project_path=project_dir, manifest_path=project_dir / "target" / "manifest.json", install_dbt_deps=False),
        profile_config=ProfileConfig(profile_name=profile_name, target_name="dev", profiles_yml_filepath=project_dir / "profiles.yml"),
        render_config=RenderConfig(load_method=LoadMode.DBT_MANIFEST, emit_datasets=False),
        execution_config=ExecutionConfig(execution_mode=ExecutionMode.WATCHER),
        operator_args={"install_deps": False},
        default_args={"retries": 1, "retry_delay": timedelta(seconds=0)},
        schedule=None,
        start_date=datetime(2024, 1, 1),
        catchup=False,
        is_paused_upon_creation=False,
        tags=["bench"],
    )
    instrument_producer(dag.get_task("dbt_producer_watcher"))
    globals()[dag_id] = dag
