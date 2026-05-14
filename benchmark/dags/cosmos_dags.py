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

from cosmos import DbtDag, ProjectConfig, ProfileConfig, RenderConfig
from cosmos.constants import TestBehavior
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
