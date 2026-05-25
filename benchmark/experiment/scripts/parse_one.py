"""
Minimal harness for measuring Cosmos DAG parse time for one DAG, one load mode.

Constructs a single DbtDag (which makes Cosmos run its parse path and emit the
"It took Xs to parse the dbt project for DAG using LoadMode.X" log line),
then exits. The real DAG file (benchmark/dags/cosmos_dags.py) constructs
multiple DAGs in one Python process; this script isolates one DAG so a single
measurement is unambiguous and the render config can be swapped per run.

Usage examples:
  python parse_one.py --load-mode DBT_LS
  python parse_one.py --load-mode DBT_MANIFEST --manifest-path /opt/airflow/target/manifest.json
  python parse_one.py --load-mode DBT_LS_FILE --ls-file-path /tmp/dbt_ls.txt
  python parse_one.py --load-mode DBT_LS --project-path /tmp/dbt_project   # for DBT_LS_CACHE experiments
  python parse_one.py --load-mode DBT_LS --install-deps                    # cold-pod scenario

Caveat: LoadMode.DBT_LS_CACHE is an internal marker Cosmos sets on cache HIT.
To exercise it, pass --load-mode DBT_LS with Cosmos caches enabled
(AIRFLOW__COSMOS__ENABLE_CACHE=1 etc.) and run twice — the second run will
report DBT_LS_CACHE if the project folder hash didn't change in between.
"""

import argparse
import logging
from pathlib import Path

from cosmos import DbtDag, ProjectConfig, ProfileConfig, RenderConfig
from cosmos.constants import LoadMode, TestBehavior


def main() -> None:
    parser = argparse.ArgumentParser(description="Trigger a single Cosmos DAG parse.")
    parser.add_argument(
        "--load-mode",
        choices=["DBT_LS", "DBT_MANIFEST", "DBT_LS_FILE", "AUTOMATIC"],
        default="DBT_LS",
    )
    parser.add_argument("--project-path", default="/opt/airflow")
    parser.add_argument("--manifest-path", default=None, help="Required for DBT_MANIFEST.")
    parser.add_argument("--ls-file-path", default=None, help="Required for DBT_LS_FILE.")
    parser.add_argument("--profile-name", default="fhir_dbt_analytics")
    parser.add_argument("--target-name", default="dev")
    parser.add_argument("--profiles-yml", default=None, help="Defaults to <project-path>/profiles.yml.")
    parser.add_argument("--dag-id", default="example_dbt_dag")
    parser.add_argument(
        "--install-deps",
        action="store_true",
        help="If set, Cosmos runs `dbt deps` as part of parsing (cold-pod scenario).",
    )
    args = parser.parse_args()

    logging.basicConfig(level=logging.INFO, format="%(message)s")

    project_path = Path(args.project_path)
    profiles_yml = Path(args.profiles_yml) if args.profiles_yml else project_path / "profiles.yml"
    load_method = LoadMode(args.load_mode.lower())

    project_kwargs = {
        "dbt_project_path": project_path,
        "install_dbt_deps": args.install_deps,
    }
    if args.manifest_path:
        project_kwargs["manifest_path"] = Path(args.manifest_path)

    render_kwargs = {
        "load_method": load_method,
        "test_behavior": TestBehavior.NONE,
    }
    if args.ls_file_path:
        render_kwargs["dbt_ls_path"] = Path(args.ls_file_path)

    DbtDag(
        project_config=ProjectConfig(**project_kwargs),
        profile_config=ProfileConfig(
            profile_name=args.profile_name,
            target_name=args.target_name,
            profiles_yml_filepath=profiles_yml,
        ),
        render_config=RenderConfig(**render_kwargs),
        schedule=None,
        catchup=False,
        dag_id=args.dag_id,
    )


if __name__ == "__main__":
    main()
