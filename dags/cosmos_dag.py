from datetime import datetime

from cosmos.airflow.dag import DbtDag
from cosmos.config import ProjectConfig, RenderConfig
from cosmos.constants import LoadMode, InvocationMode, TestBehavior
from include.profiles import bigquery_db
from include.constants import venv_execution_config

from pathlib import Path


cosmos_dag = DbtDag(
    project_config=ProjectConfig(Path("/usr/local/airflow/dbt/fhir-dbt-analytics")),
    profile_config=bigquery_db,
    execution_config=venv_execution_config,
    # normal dag parameters
    schedule=None,
    start_date=datetime(2023, 1, 1),
    catchup=False,
    dag_id="cosmos_dag",
    tags=["simple"],
    default_args={
        "retries": 2,
    },
)
