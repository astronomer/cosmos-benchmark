"""Benchmark DAG: parse a 3000-node synthetic dbt project using
LoadMode.DBT_MANIFEST + a complex selector expression.

Project: synthetic_large_dbt_project, expected at
/usr/local/airflow/dbt/synthetic_large_dbt_project (bind-mount the dbt
project from this repo).
"""

from datetime import datetime
from pathlib import Path

from cosmos import DbtDag, ProfileConfig, ProjectConfig, RenderConfig
from cosmos.constants import LoadMode
from cosmos.profiles import PostgresUserPasswordProfileMapping

DBT_PROJECT_PATH = Path("/usr/local/airflow/dbt/synthetic_large_dbt_project")

synthetic_select_dbt_manifest = DbtDag(
    project_config=ProjectConfig(
        dbt_project_path=DBT_PROJECT_PATH,
        manifest_path=DBT_PROJECT_PATH / "target" / "manifest.json",
    ),
    profile_config=ProfileConfig(
        profile_name="synthetic_large_dbt_project",
        target_name="dev",
        profile_mapping=PostgresUserPasswordProfileMapping(
            conn_id="postgres_default",
            profile_args={"schema": "public"},
        ),
    ),
    render_config=RenderConfig(
        load_method=LoadMode.DBT_MANIFEST,
        select=["+tag:mart+", "+tag:int+1", "tag:critical,tag:domain_sales"],
        exclude=["tag:deprecated", "tag:flaky"],
    ),
    schedule=None,
    start_date=datetime(2024, 1, 1),
    catchup=False,
    dag_id="synthetic_select_dbt_manifest",
    tags=["benchmark", "synthetic"],
    is_paused_upon_creation=False,
)
