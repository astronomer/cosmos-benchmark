# synthetic_large_dbt_project

A generated dbt project for stress-testing Cosmos's parse-time path —
specifically the cost of `select_nodes()` over a large node graph with
non-trivial selector expressions.

Unlike `altered_jaffle_shop` and `fhir-dbt-analytics`, this project is
**synthetic** (no real semantics) and **purpose-built** for benchmarks.
Models contain trivial SQL (`select 1 as id`); the value is in the shape
of the graph and the tag set, not in the data they would produce.

## Shape

- **3000 models** by default, spread across four layers:
  - `raw` (~750), `stg` (~750), `int` (~750), `mart` (~750)
- Each model in layer N references 1–3 random models in layer N-1.
  `raw` models reference `seed_dim`.
- Tags assigned per model:
  - layer tag (`raw` / `stg` / `int` / `mart`) + a layer-class tag
    (`source_data`, `transform`, `reporting`)
  - domain tag (`domain_sales` / `domain_finance` / `domain_ops` /
    `domain_marketing` / `domain_product`)
  - criticality tag (`critical` / `standard` / `deprecated`)
  - occasional cross-cutting tags (`flaky`, `expensive`)

This gives selector expressions like
`["+tag:mart+", "+tag:int+1", "tag:critical,tag:domain_sales"]` enough
graph + tag combinatorics to push `select_nodes()` into the seconds range.

## Regenerating

```bash
cd dbt/synthetic_large_dbt_project
python3 scripts/generate_project.py --n-models 3000
```

The generator is deterministic for a given `--rng-seed` (default `42`),
so re-runs produce the same project. The flag is named `--rng-seed`
(not `--seed`) to avoid collision with dbt's "seed" concept — dbt seeds
are static CSVs loaded into the warehouse (see `seeds/seed_dim.csv`);
this flag is for Python's `random.Random()`. Pass a different
`--n-models` to scale up or down.

A pre-built `target/manifest.json` is committed so consumers can use
`LoadMode.DBT_MANIFEST` without running dbt locally. If you regenerate
or scale the project, re-run `dbt parse` (with the local-postgres
profile in `profiles.yml`) to refresh `target/`.

## Usage from a Cosmos DAG

```python
from cosmos import DbtDag, ProfileConfig, ProjectConfig, RenderConfig
from cosmos.constants import LoadMode
from cosmos.profiles import PostgresUserPasswordProfileMapping
from pathlib import Path

DBT_PROJECT_PATH = Path("/usr/local/airflow/dbt/synthetic_large_dbt_project")

dag = DbtDag(
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
)
```

Task SQL is intentionally trivial — these models can be `dbt run` against
any Postgres for sanity, but the project's purpose is parse-time
measurement, not data correctness.
