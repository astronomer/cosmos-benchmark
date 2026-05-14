from datetime import datetime
from pathlib import Path

from cosmos import DbtDag, ExecutionConfig, ExecutionMode, ProfileConfig, ProjectConfig
from cosmos.operators._asynchronous.bigquery import DbtRunAirflowAsyncBigqueryOperator
from cosmos.profiles import GoogleCloudServiceAccountDictProfileMapping
from include.constants import BIGQUERY_DATASET, DBT_ADAPTER_VERSION, GCP_PROJECT_ID

DBT_PROJECT_PATH = Path("/usr/local/airflow/dbt/altered_jaffle_shop")



profile_config = ProfileConfig(
    profile_name="altered_jaffle_shop",
    target_name="dev",
    profile_mapping=GoogleCloudServiceAccountDictProfileMapping(
        conn_id="gcp_gs_conn", profile_args={"dataset": BIGQUERY_DATASET, "project": GCP_PROJECT_ID}
    ),
)


cosmos_bq_sync = DbtDag(
    # dbt/cosmos-specific parameters
    project_config=ProjectConfig(DBT_PROJECT_PATH),
    profile_config=profile_config,
    execution_config=ExecutionConfig(
        execution_mode=ExecutionMode.AIRFLOW_ASYNC,
        async_py_requirements=[f"dbt-bigquery=={DBT_ADAPTER_VERSION}"],
    ),
    # normal dag parameters
    schedule=None,
    start_date=datetime(2026, 1, 1),
    catchup=False,
    dag_id="cosmos_bq_sync",
    tags=["simple"],
    operator_args={
        "location": "US",
        "install_deps": True,
        "full_refresh": True,
    },
)

for task in cosmos_bq_sync.tasks:
    if isinstance(task, DbtRunAirflowAsyncBigqueryOperator):
        task.deferrable = False
