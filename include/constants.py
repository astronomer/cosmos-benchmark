"Contains constants used in the DAGs"

import os
from pathlib import Path
from cosmos import ExecutionConfig

DBT_ADAPTER_VERSION = os.getenv("DBT_ADAPTER_VERSION", "1.9")
GCP_PROJECT_ID = os.getenv("GCP_PROJECT_ID", "astronomer-dag-authoring")
BIGQUERY_DATASET = os.getenv("BIGQUERY_DATASET", "cosmos_async_bechmark_test")
dbt_executable = Path("/usr/local/airflow/dbt_venv/bin/dbt")

venv_execution_config = ExecutionConfig(
    dbt_executable_path=str(dbt_executable),
)
