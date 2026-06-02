# Airflow DAG to compare the performance of running dbt Core commands in Airflow using the DbtDag and DbtBuildLocalOperator
from datetime import datetime
from pathlib import Path

try:
    from airflow import DAG
except ImportError:
    from airflow.sdk import DAG

try:
    from airflow.sdk import get_parsing_context
except ImportError:
    from airflow.utils.dag_parsing_context import get_parsing_context

from cosmos import DbtDag, DbtTaskGroup, ProjectConfig, ProfileConfig, RenderConfig, ExecutionConfig
from cosmos.constants import TestBehavior, ExecutionMode, LoadMode
from cosmos import DbtBuildLocalOperator, DbtRunLocalOperator, DbtSeedLocalOperator, DbtTestLocalOperator


DBT_PROJECT_PATH = Path(__file__).parent.parent

current_dag_id = get_parsing_context().dag_id

project_config = ProjectConfig(
    dbt_project_path=DBT_PROJECT_PATH,
    install_dbt_deps=False,
)

profile_config = ProfileConfig(
    profile_name="fhir_dbt_analytics",
    target_name="dev",
    profiles_yml_filepath=DBT_PROJECT_PATH / "profiles.yml",
)

if current_dag_id is None or current_dag_id == "example_dbt_dag":
    example_dbt_dag = DbtDag(
        project_config=project_config,
        profile_config=profile_config,
        render_config=RenderConfig(test_behavior=TestBehavior.NONE),
        schedule=None,
        catchup=False,
        dag_id="example_dbt_dag",
        tags=["profiles"],
        is_paused_upon_creation=False
    )

if current_dag_id is None or current_dag_id == "example_dbt_dag_watcher":
    example_dbt_dag_watcher = DbtDag(
        project_config=project_config,
        profile_config=profile_config,
        execution_config=ExecutionConfig(execution_mode=ExecutionMode.WATCHER),
        render_config=RenderConfig(test_behavior=TestBehavior.NONE),
        schedule=None,
        catchup=False,
        dag_id="example_dbt_dag_watcher",
        tags=["profiles"],
        is_paused_upon_creation=False
    )

if current_dag_id is None or current_dag_id == "example_operator_build":
    with DAG(
        "example_operator_build",
        schedule=None,
        catchup=False,
        is_paused_upon_creation=False,
    ) as dag:
        build = DbtBuildLocalOperator(
            task_id="build",
            profile_config=profile_config,
            project_dir=DBT_PROJECT_PATH,
            operator_args={"install_deps": False},
        )
        build


# ---------------------------------------------------------------------------
# BOSS-418: WATCHER sensor memory vs. number of Cosmos task groups.
#
# In WATCHER mode every sensor task re-imports the DAG on its worker at startup,
# which instantiates *every* DbtTaskGroup in the file — and each group does a
# full manifest parse + graph build. So per-sensor peak RSS grows linearly with
# the number of task groups (and with manifest size), even though the sensor
# runs no dbt. Measured (Cosmos debug mode, cosmos_debug_max_memory_mb):
#
#   manifest    1 group   5 groups   10 groups   13 groups   slope
#   3,000 nodes   322 MB     380 MB      424 MB       —       11.3 MB/group
#   23,000 nodes  486 MB     865 MB     1295 MB    1555 MB    88.7 MB/group  (R²=0.9995)
#
# 23k × 13 groups ≈ 1.55 GB reproduces the Medtronic report (~1.1 GB). Mitigation:
# fewer task groups (each group ≈ +89 MB/sensor on a 23k manifest). Build the image
# with --build-arg N_MODELS=23000 to reproduce the large-manifest numbers.
#
# Each task group selects a disjoint block of raw-layer models (raw `ref`s only
# `seed_dim`, so each slice builds standalone once seed_dim is seeded).
# ---------------------------------------------------------------------------

SYNTHETIC_PROJECT_PATH = Path("/opt/airflow/dbt/synthetic_large_dbt_project")
SYNTHETIC_GROUP_SIZE = 5  # models (=sensors) per task group; per-sensor RSS is
                          # independent of this — it's driven by the group count.

synthetic_project_config = ProjectConfig(
    dbt_project_path=SYNTHETIC_PROJECT_PATH,
    manifest_path=SYNTHETIC_PROJECT_PATH / "target" / "manifest.json",
    install_dbt_deps=False,
)

synthetic_profile_config = ProfileConfig(
    profile_name="synthetic_large_dbt_project",
    target_name="dev",
    profiles_yml_filepath=SYNTHETIC_PROJECT_PATH / "profiles.yml",
)


def _synthetic_watcher_task_group(group_index):
    """One WATCHER task group selecting a disjoint raw-layer block of
    SYNTHETIC_GROUP_SIZE models, starting at group_index * SYNTHETIC_GROUP_SIZE."""
    start = group_index * SYNTHETIC_GROUP_SIZE
    select = [f"model_{i:05d}" for i in range(start, start + SYNTHETIC_GROUP_SIZE)]
    return DbtTaskGroup(
        group_id=f"tg_{group_index:02d}",
        project_config=synthetic_project_config,
        profile_config=synthetic_profile_config,
        execution_config=ExecutionConfig(execution_mode=ExecutionMode.WATCHER),
        render_config=RenderConfig(
            load_method=LoadMode.DBT_MANIFEST,
            select=select,
            test_behavior=TestBehavior.NONE,
            # The synthetic profile templates host/port via env_var(), so the
            # Asset (Dataset) outlet URI would carry literal `{{ env_var(...) }}`
            # — an invalid Airflow 3 URI that makes the consumer sensor raise on
            # success. Datasets are irrelevant to this memory benchmark, so off.
            emit_datasets=False,
        ),
        # Non-deferrable poke-mode sensors stay resident in the worker for their
        # whole life (matching how Medtronic's sensors hold a slot), so debug mode
        # captures the full sensor-lifetime peak RSS. The producer operator filters
        # out unknown kwargs, so this flag only reaches the sensor.
        operator_args={"deferrable": False},
    )


# (dag_id, number of task groups) — sensors per DAG = groups * SYNTHETIC_GROUP_SIZE.
SYNTHETIC_WATCHER_CONFIGS = [
    ("synthetic_watcher_1tg", 1),
    ("synthetic_watcher_5tg", 5),
    ("synthetic_watcher_10tg", 10),
    ("synthetic_watcher_13tg", 13),
]

for _dag_id, _n_groups in SYNTHETIC_WATCHER_CONFIGS:
    if current_dag_id is None or current_dag_id == _dag_id:
        with DAG(
            _dag_id,
            schedule=None,
            catchup=False,
            start_date=datetime(2024, 1, 1),
            is_paused_upon_creation=False,
            tags=["boss-418", "watcher", "synthetic"],
        ) as _dag:
            for _gi in range(_n_groups):
                _synthetic_watcher_task_group(_gi)
        globals()[_dag_id] = _dag
