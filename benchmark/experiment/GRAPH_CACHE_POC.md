# Cosmos parse-time graph-cache POC

A small monkey-patch that takes Cosmos DAG parsing for `example_dbt_dag`
(240 dbt nodes, 9 installed packages) from **~67 ms (DBT_LS_FILE) → ~5 ms**
with no upstream Cosmos changes.

## The idea

The benchmark image is immutable: once we bake the dbt project into a tagged
image, the parsed dbt graph cannot drift from the source until we build a new
image. That makes content-hash-based cache invalidation unnecessary — the
image identity *is* the validity signal.

The POC exploits this twice:

1. **Pickle the parsed `DbtGraph.nodes` dict at image-build time** and write
   it next to `dbt_ls.json` as `dbt_ls.json.pkl`. At runtime, monkey-patch
   `DbtGraph.load_via_dbt_ls_file` to unpickle directly (~1.5 ms) instead of
   re-parsing JSON.
2. **Constant-fold `_create_folder_version_hash`** to the static string
   `"image-build"`. That function recursively reads every file in the project
   folder (tens of MB) to compute a hash whose only consumer that affects
   correctness is `DBT_LS_CACHE` invalidation — which we don't use. The other
   consumer (the project-hash label in `dag.doc_md`) is purely cosmetic.

Net effect: ~62 ms shaved off every parse, with the same DAG structure and
identical task execution behaviour (the patch only touches DAG-parse-time
code paths, not the `dbtRunner` invocations operators use at task time).

## Results

`example_dbt_dag`, 5 fresh containers per setup, all Cosmos caches disabled
(`AIRFLOW__COSMOS__ENABLE_CACHE*=0`):

| LoadMode                                | Mean      | Median    | Min       | Max       |
|-----------------------------------------|-----------|-----------|-----------|-----------|
| `DBT_LS`                                | 19.060 s  | 19.500 s  | 16.600 s  | 21.000 s  |
| `DBT_MANIFEST`                          |  1.328 s  |  1.320 s  |  1.320 s  |  1.350 s  |
| `DBT_LS_CACHE`                          |  0.134 s  |  0.133 s  |  0.130 s  |  0.137 s  |
| `DBT_LS_FILE` (baseline, no POC)        |  0.0672 s |  0.0656 s |  0.0650 s |  0.0741 s |
| **`DBT_LS_FILE` + graph-cache POC**     | **0.00495 s** | **0.00483 s** | **0.00472 s** | **0.00557 s** |

→ **~13× faster than DBT_LS_FILE, ~3,800× faster than cold DBT_LS.**

## End-to-end correctness

Ran `airflow dags test example_dbt_dag` against BigQuery with the POC active:

| Check                  | Result                                        |
|------------------------|-----------------------------------------------|
| DAG run state          | **success**                                   |
| Exit code              | **0**                                         |
| Tasks succeeded        | **188**                                       |
| Tasks failed           | **0**                                         |
| Node count             | **240** (unchanged)                           |
| Parse time             | **7.94 ms** (vs 7.88 s on the no-POC e2e run) |
| `LoadMode` reported    | `DBT_LS_FILE` ✓                               |
| Graph cache HITs       | 1 (fires once per DAG-import process) ✓       |

## How to reproduce

Prerequisites: Docker daemon, `python3` on PATH. No Kubernetes required.

```bash
cd /Users/pankaj.singh/Documents/astro_code/cosmos-benchmark

# One-shot script that builds the image (if missing), then runs the
# A/B benchmark: N parses without the POC, then N parses with the POC.
./benchmark/experiment/scripts/measure-poc.sh             # 5 runs each, ~1 min
./benchmark/experiment/scripts/measure-poc.sh 10          # 10 runs each
./benchmark/experiment/scripts/measure-poc.sh 5 rebuild   # force rebuild first
```

The "without POC" path is exercised by passing
`COSMOS_GRAPH_CACHE_POC_DISABLE=1` to the container — the same image, same
DAG file, same artifacts. Only the monkey-patch is bypassed.

Expected output:

```
==> WITHOUT POC (DBT_LS_FILE baseline, 5 fresh containers)
  Run #1: 0.0687s
  ...
  Summary: mean=66.14ms median=65.00ms min=64.60ms max=68.70ms stdev=1.96ms

==> WITH POC    (graph cache + static folder hash, 5 fresh containers)
  Run #1: 0.00479s
  ...
  Summary: mean=4.95ms median=4.83ms min=4.79ms max=5.47ms stdev=0.29ms

==> Speedup: 13.4x  (66.14ms → 4.95ms)
```

## What's in this branch (additions over the no-POC `cosmos-loadmode-benchmark` branch)

- `benchmark/experiment/scripts/dbt_graph_cache_poc.py` — the two
  monkey-patches (`DbtGraph.load_via_dbt_ls_file` + the three
  `_create_folder_version_hash` import bindings).
- `benchmark/experiment/scripts/measure-poc.sh` — the A/B benchmark harness.
- `benchmark/Dockerfile` — one extra `RUN python -c "...pickle.dump..."` to
  pre-bake `/opt/airflow/dbt_ls.json.pkl` at image-build time, plus a
  `COPY` of `dbt_graph_cache_poc.py` into `/opt/airflow/`.
- `benchmark/dags/cosmos_dags.py` — `import dbt_graph_cache_poc;
  dbt_graph_cache_poc.install()` near the top, after the cosmos imports.

## Caveats

1. **The folder-hash skip is unsafe if you use `DBT_LS_CACHE`.** Cosmos's
   `DBT_LS_CACHE` invalidation relies on the folder hash to detect project
   changes. The POC's static-hash patch will make cached graphs look "still
   fresh" forever. Since this benchmark uses `DBT_LS_FILE` (where the
   pickle's existence is the validity signal) it's safe — but don't blindly
   ship this for `DBT_LS_CACHE` deployments.
2. **`COSMOS_GRAPH_CACHE_POC_DISABLE=1`** is the off-switch for A/B testing
   in the same image. Useful for proving the patch is what's saving the
   time, not some other build-step change.
3. The patch is ~80 lines and lives entirely outside Cosmos. The right
   upstream fix would be (a) an opt-in `dbt_graph_pickle_path` parameter on
   `RenderConfig`, and (b) scoping the folder-hash walk to source dirs
   (`models/`, `macros/`, `seeds/`) instead of the whole project tree.

## See also

The same parse-time numbers for the four upstream `LoadMode`s (`DBT_LS`,
`DBT_MANIFEST`, `DBT_LS_CACHE`, `DBT_LS_FILE`) — measured the same way but
without the POC — are documented on the `cosmos-loadmode-benchmark` branch.
