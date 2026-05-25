# Cosmos LoadMode parse-time benchmark

How long does Cosmos take to parse `example_dbt_dag` (240 dbt nodes, 9 installed
dbt packages) into an Airflow DAG, broken down by `LoadMode`?

## What's in this branch

- `benchmark/Dockerfile` pre-generates every dbt artifact each LoadMode can
  reuse, all at image-build time:
  - `dbt deps`  → `dbt_packages/`
  - `dbt parse` → `target/manifest.json` + `target/partial_parse.msgpack`
  - `dbt ls --output json` → `/opt/airflow/dbt_ls.json`
- `benchmark/patches/packages.yml` adds a heavier package set on top of
  fhir-dbt-analytics's upstream four, so `dbt deps` does enough work to make
  the timing differences visible.
- `benchmark/experiment/scripts/parse_one.py` is a minimal harness: it
  constructs exactly one `DbtDag` and exits, so the Cosmos parse-time log
  line `It took Xs to parse the dbt project for DAG using LoadMode.X` fires
  once per run. CLI args let you swap LoadModes without touching any DAG file.
- `benchmark/dags/cosmos_dags.py` defaults to `LoadMode.DBT_LS_FILE` (fastest
  of the four upstream modes).

## Results

`example_dbt_dag`, 5 fresh containers per LoadMode, all Cosmos caches disabled
(`AIRFLOW__COSMOS__ENABLE_CACHE*=0`):

| LoadMode       | Mean      | Median    | Min       | Max       |
|----------------|-----------|-----------|-----------|-----------|
| `DBT_LS`       | 19.060 s  | 19.500 s  | 16.600 s  | 21.000 s  |
| `DBT_MANIFEST` |  1.328 s  |  1.320 s  |  1.320 s  |  1.350 s  |
| `DBT_LS_CACHE` |  0.134 s  |  0.133 s  |  0.130 s  |  0.137 s  |
| `DBT_LS_FILE`  |  0.064 s  |  0.063 s  |  0.062 s  |  0.070 s  |

Notes per mode:
- **`DBT_LS`** with `install_dbt_deps=True` represents a truly cold pod —
  Cosmos runs `dbt deps` + `dbt ls` inside the parse window. Variance is
  network-bound (dbt-hub fetches).
- **`DBT_MANIFEST`** reads the pre-built `target/manifest.json`.
- **`DBT_LS_CACHE`** measures cache *hits* only. The first parse is always a
  miss (~7 s) — only subsequent in-process parses with an unchanged project
  folder hit the cache. Requires the dbt project to be **outside**
  `AIRFLOW_HOME`, otherwise Airflow's own writes invalidate the hash.
- **`DBT_LS_FILE`** reads the pre-rendered `/opt/airflow/dbt_ls.json`.

## How to reproduce

Prerequisites: Docker daemon, `python3` on PATH. No Kubernetes required.

```bash
cd /Users/pankaj.singh/Documents/astro_code/cosmos-benchmark

# 1. Build the benchmark image (pre-generates dbt artifacts during build).
docker build -t benchmark:0.0.3 -f benchmark/Dockerfile .

# 2. Common env: disable every Cosmos cache so we measure raw parse time.
CACHE_OFF=(
  -e AIRFLOW__COSMOS__ENABLE_CACHE=0
  -e AIRFLOW__COSMOS__ENABLE_CACHE_PARTIAL_PARSE=0
  -e AIRFLOW__COSMOS__ENABLE_CACHE_PACKAGE_LOCKFILE=0
  -e AIRFLOW__COSMOS__ENABLE_CACHE_DBT_LS=0
  -e AIRFLOW__COSMOS__ENABLE_CACHE_DBT_YAML_SELECTORS=0
  -e AIRFLOW__COSMOS__ENABLE_CACHE_PROFILE=0
)

# Helper: extract parse time from the Cosmos log.
PARSE='python /opt/airflow/parse_one.py "$@" 2>&1 \
       | grep "to parse the dbt project for DAG using LoadMode" \
       | tail -1 | grep -oE "It took [0-9.]+s"'
```

### DBT_LS (true cold pod, deps + ls run inside parse)

Five fresh containers, fresh `/tmp/`, no pre-installed `dbt_packages/`.

```bash
for i in 1 2 3 4 5; do
  docker run --rm "${CACHE_OFF[@]}" benchmark:0.0.3 bash -c '
    airflow db migrate >/dev/null 2>&1
    rm -rf /opt/airflow/dbt_packages   # force a true cold parse
    cd /opt/airflow
    python parse_one.py --load-mode DBT_LS --install-deps 2>&1 \
      | grep "to parse the dbt project for DAG using LoadMode" \
      | tail -1 | grep -oE "It took [0-9.]+s"
  '
done
```

### DBT_MANIFEST (pre-built target/manifest.json)

The Dockerfile already ran `dbt parse`, so `target/manifest.json` is in the image.

```bash
for i in 1 2 3 4 5; do
  docker run --rm "${CACHE_OFF[@]}" benchmark:0.0.3 bash -c '
    airflow db migrate >/dev/null 2>&1
    cd /opt/airflow
    python parse_one.py --load-mode DBT_MANIFEST \
                        --manifest-path /opt/airflow/target/manifest.json 2>&1 \
      | grep "to parse the dbt project for DAG using LoadMode" \
      | tail -1 | grep -oE "It took [0-9.]+s"
  '
done
```

### DBT_LS_FILE (pre-rendered dbt_ls.json)

```bash
for i in 1 2 3 4 5; do
  docker run --rm "${CACHE_OFF[@]}" benchmark:0.0.3 bash -c '
    airflow db migrate >/dev/null 2>&1
    cd /opt/airflow
    python parse_one.py --load-mode DBT_LS_FILE \
                        --ls-file-path /opt/airflow/dbt_ls.json 2>&1 \
      | grep "to parse the dbt project for DAG using LoadMode" \
      | tail -1 | grep -oE "It took [0-9.]+s"
  '
done
```

### DBT_LS_CACHE (cache hits, single container)

Cache lives in an Airflow Variable, so we measure 6 parses in one container
and report the last 5 (the first is always a miss).

```bash
docker run --rm \
  -e AIRFLOW__COSMOS__ENABLE_CACHE=1 \
  -e AIRFLOW__COSMOS__ENABLE_CACHE_DBT_LS=1 \
  benchmark:0.0.3 bash -c '
    airflow db migrate >/dev/null 2>&1
    # Move the dbt project outside AIRFLOW_HOME so Airflow writes
    # (logs/sqlite) do NOT invalidate the project folder hash.
    mkdir -p /tmp/dbt_project && \
      cp -r /opt/airflow/dbt_project.yml /opt/airflow/models /opt/airflow/macros \
            /opt/airflow/seeds /opt/airflow/profiles.yml /opt/airflow/packages.yml \
            /opt/airflow/package-lock.yml /opt/airflow/dbt_packages \
            /opt/airflow/selectors.yml /tmp/dbt_project/
    for i in 1 2 3 4 5 6; do
      python /opt/airflow/parse_one.py --load-mode DBT_LS \
                                       --project-path /tmp/dbt_project 2>&1 \
        | grep "to parse the dbt project for DAG using LoadMode" \
        | tail -1 | grep -oE "It took [0-9.]+s.*LoadMode\.[A-Z_]+"
    done
  '
```

### Helper: parse-time line in k8s job logs

`benchmark/post-process/check-parse-time.sh` greps the same Cosmos parse-time
log line out of a job pod's stdout when running via `benchmark/run-test.sh`.
That gives you the same number under the real benchmark Job experiments.

## Known gotchas

1. **`DBT_LS_CACHE` silently degrades to `DBT_LS` when the dbt project lives
   inside `AIRFLOW_HOME`.** The cache invalidator walks the entire project
   folder; Airflow writes (logs, sqlite db) change that hash on every parse
   and Cosmos always falls back to "Cache miss — skipped".
2. **`AIRFLOW__COSMOS__PROPAGATE_LOGS=0`** in `benchmark/Dockerfile` is a
   deprecated no-op since Cosmos 1.6.0. Harmless but removable.
3. The `target/` directory contents drift between two consecutive
   `dbt parse`/`dbt ls` invocations, so any folder-hash-based cache check
   that includes `target/` will report "modified" on every parse.

## Takeaways

- Switching from `DBT_LS` to **`DBT_LS_FILE`** is a ~285× parse-time win
  with one new build step (`dbt ls --output json > dbt_ls.json`) and one
  config flip (`load_method=LoadMode.DBT_LS_FILE`).
- `DBT_LS_CACHE` is only useful in long-running dag-processor environments,
  not for per-pod k8s Jobs where the metadata DB is ephemeral.
- Always run `dbt deps` at image-build time; it saves ~13 s per pod-start
  and is orthogonal to your LoadMode choice.
