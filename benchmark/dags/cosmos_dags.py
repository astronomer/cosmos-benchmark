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

from cosmos import DbtDag, ProjectConfig, ProfileConfig, RenderConfig, ExecutionConfig
from cosmos.constants import LoadMode, TestBehavior, ExecutionMode
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

# Pre-rendered dbt ls output baked into the image at /opt/airflow/dbt_ls.json
# (see benchmark/Dockerfile). LoadMode.DBT_LS_FILE skips the dbt subprocess
# entirely at DAG-parse time and is the fastest of the four upstream modes.
render_config = RenderConfig(
    load_method=LoadMode.DBT_LS_FILE,
    dbt_ls_path=DBT_PROJECT_PATH / "dbt_ls.json",
    test_behavior=TestBehavior.NONE,
)

if current_dag_id is None or current_dag_id == "example_dbt_dag":
    example_dbt_dag = DbtDag(
        project_config=project_config,
        profile_config=profile_config,
        render_config=render_config,
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
        render_config=render_config,
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
