from datetime import datetime
import os
from datetime import datetime
from pathlib import Path

from airflow import DAG

from cosmos import DbtDag, DbtTaskGroup
from cosmos.config import ExecutionConfig, ProjectConfig, RenderConfig
from cosmos.constants import ExecutionMode, LoadMode, InvocationMode, TestBehavior
from include.profiles import bigquery_db
from include.constants import venv_execution_config

from pathlib import Path


cosmos_dag = DbtDag(
    project_config=ProjectConfig(Path("/usr/local/airflow/dbt/fhir-dbt-analytics")),
    profile_config=bigquery_db,
    execution_config=venv_execution_config,
    render_config=RenderConfig(
        test_behavior=TestBehavior.NONE
    ),
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


with DAG(
    dag_id="cosmos_task_group",
    schedule=None,
    catchup=False,
    start_date=datetime(2025, 8, 1),
    default_args={"retries": 0},
):

    views = DbtTaskGroup(
        group_id="views",
        project_config=ProjectConfig(Path("/usr/local/airflow/dbt/fhir-dbt-analytics")),
        render_config=RenderConfig(
            select=["+config.materialized:view"],
            exclude=["*metric*"],
            enable_mock_profile=False,
            test_behavior=TestBehavior.NONE
        ),
        execution_config=venv_execution_config,
        operator_args={"install_deps": True},
        profile_config=bigquery_db,
    )

    non_views = DbtTaskGroup(
        group_id="views_downstream",
        project_config=ProjectConfig(Path("/usr/local/airflow/dbt/fhir-dbt-analytics")),
        render_config=RenderConfig(
            exclude=["config.materialized:view"],
            select=["config.materialized:view+", "*metric*"],
            enable_mock_profile=False,
            test_behavior=TestBehavior.NONE
        ),
        execution_config=ExecutionConfig(
            execution_mode=ExecutionMode.AIRFLOW_ASYNC,
            async_py_requirements=[f"dbt-bigquery"],
        ),
        operator_args={
            "location": "US",
            "install_deps": True
        },
        profile_config=bigquery_db,
    )

    views >> non_views
