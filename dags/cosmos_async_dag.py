import os
from datetime import datetime
from pathlib import Path

from cosmos import DbtDag, ExecutionConfig, ExecutionMode, ProfileConfig, ProjectConfig, RenderConfig
from cosmos.profiles import GoogleCloudServiceAccountDictProfileMapping

DBT_PROJECT_PATH = Path("/usr/local/airflow/dbt/altered_jaffle_shop")

DBT_ADAPTER_VERSION = os.getenv("DBT_ADAPTER_VERSION", "1.9")

profile_config = ProfileConfig(
    profile_name="default",
    target_name="dev",
    profile_mapping=GoogleCloudServiceAccountDictProfileMapping(
        conn_id="gcp_gs_conn", profile_args={"dataset": "test_async", "project": "astronomer-airflow-providers"}
    ),
)


# [START airflow_async_execution_mode_example]
simple_dag_async = DbtDag(
    # dbt/cosmos-specific parameters
    project_config=ProjectConfig(DBT_PROJECT_PATH),
    profile_config=profile_config,
    execution_config=ExecutionConfig(
        execution_mode=ExecutionMode.AIRFLOW_ASYNC,
        async_py_requirements=[f"dbt-bigquery=={DBT_ADAPTER_VERSION}"],
    ),
    # normal dag parameters
    schedule=None,
    start_date=datetime(2023, 1, 1),
    catchup=False,
    dag_id="simple_dag_async",
    tags=["simple"],
    operator_args={
        "location": "US",
        "install_deps": True,
        "full_refresh": True,
    },
)
