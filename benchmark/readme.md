Benchmark
=========

The goal of this project is to help comparing and analysing the performance of running dbt Core, dbt Cloud and dbt in Airflow with Astronomer Cosmos. As a starting point the tests are being run using the Airflow Helmchart - but the idea is that in future we'll extend these tests to also compare the performance in Astro Cloud.

The perfomance is analysed from three perspectives:

* Time to complete the execution of the DAG
* Total memory consumed
* Total vCPU consumed

These metrics can be extended over time. One component we would like to evaluate in the future is the time taken for data freshness checks.

For the tests to be fair, except for dbt Cloud (since we don't control it), we will run them using a similar "hardware". The tests will be run in a pod in a Kubernetes cluster with the same values for resources and limits.

As a starting point, we are running the tests against a local Kubernetes cluster, but if we want a further level of isolation, we could run them against any managed cluster.

Benchmarking LOCAL vs WATCHER execution mode
============================================

This is a Helm-based benchmark path that compares Cosmos' LOCAL execution mode against WATCHER mode end-to-end on a real Airflow installation. It deploys the official Apache Airflow Helm chart on Kind, with two worker pools — a dedicated **producer** pool that runs `dbt build` and a **consumer** pool that runs the per-model sensor tasks — and a Prometheus stack to scrape per-pool CPU and memory.

Use this path when you want apples-to-apples wall-time and resource numbers for `example_dbt_dag` (LOCAL) versus `example_dbt_dag_watcher` (WATCHER) on the same cluster.

Requirements
------------

Install on the host:
* Docker
* `kind`, `kubectl`, `helm`
* `lsof` (preinstalled on macOS; `apt-get install lsof` on Debian/Ubuntu) — used by `setup.sh` for port-forward safety
* `jq`, `python3` (preinstalled on macOS)

Provide credentials:
* `benchmark/pre-process/key.json` — GCP service-account JSON with BigQuery access. `setup.sh` validates this key before doing any work.
* If you target a different BigQuery project / dataset, update `benchmark/pre-process/profiles.yml` accordingly.

Initialize the dbt project submodule once from the repo root:

```
git submodule init
git submodule update
```

Setup
-----

From the repo root:

```
cd benchmark
./setup.sh
```

`setup.sh` is idempotent and:

1. Creates the `kind` cluster (skips if it already exists).
2. Validates `benchmark/pre-process/key.json` against GCP.
3. Installs `kube-prometheus-stack` into the `monitoring` namespace and port-forwards Prometheus on `localhost:9090`.
4. Builds the benchmark image (`apache/airflow:3.2.0` base + `dbt-bigquery` + `astronomer-cosmos`) and loads it into the kind node.
5. Installs the Apache Airflow Helm chart `1.21.0` into the `airflow` namespace using `pre-process/values.yml`.
6. Renders and applies a dedicated **producer** worker `Deployment` (derived from the chart's worker `Deployment` so ServiceAccount / ConfigMap / Secret references stay in sync).
7. Port-forwards the Airflow `api-server` on `localhost:8080`.

The producer pool is env-tunable per run:

```
PRODUCER_REPLICAS=1 PRODUCER_CPU=1 PRODUCER_MEM=2Gi PRODUCER_QUEUE=producer ./setup.sh
```

Running a benchmark
-------------------

The DAGs available are:

* `example_dbt_dag` — Cosmos LOCAL mode, one Airflow task per dbt model.
* `example_dbt_dag_watcher` — Cosmos WATCHER mode (one producer task that runs `dbt build`, one sensor per model that watches XCom).
* `example_operator_build` — single `DbtBuildLocalOperator` task.

```
cd benchmark
DAGS="example_dbt_dag_watcher" REPS=1 ./run-complex-test.sh
```

`DAGS` accepts any combination of the three DAG ids; default is all three. `REPS` defaults to 1.

After each DAG run, `run-complex-test.sh` calls `./post-process/check-helm-metrics.sh <dag-name>`, which reports:

* Wall-time of the run (from Airflow metadata).
* Producer pool, consumer pool, and total cluster CPU / memory **scoped to the DAG-run window** (so historical pod incarnations don't pollute the totals).

The metrics are produced by querying Prometheus through the port-forward — same port `setup.sh` exposes on `localhost:9090`.

Tweaking config without editing values.yml
------------------------------------------

Different producer sizing on the next setup run:

```
PRODUCER_CPU=1 PRODUCER_MEM=2Gi ./setup.sh
```

Different consumer sizing (in-place, no re-setup needed):

```
helm --kube-context kind-kind upgrade airflow apache-airflow/airflow --version 1.21.0 \
  -n airflow -f pre-process/values.yml \
  --set workers.replicas=9 \
  --set workers.resources.requests.cpu=1 --set workers.resources.limits.cpu=1 \
  --set workers.resources.requests.memory=2Gi --set workers.resources.limits.memory=2Gi \
  --set config.celery.worker_concurrency=2
```

Different dbt `threads` for WATCHER (the producer's `dbt build` honours this; LOCAL ignores it because each task selects a single model):

```
PROD=$(kubectl --context kind-kind -n airflow get pod -l cosmos-role=producer -o jsonpath='{.items[0].metadata.name}')
sed 's/threads: 4/threads: 16/' pre-process/profiles.yml > /tmp/p.yml
kubectl --context kind-kind cp -n airflow /tmp/p.yml "$PROD":/opt/airflow/profiles.yml -c worker
```

Teardown
--------

```
kind delete cluster --name kind
```

Results: LOCAL vs WATCHER (2026-05-08)
======================================

Cluster config (identical for every column):

* Apache Airflow Helm chart `1.21.0` (Airflow `3.2.0`), Cosmos `1.14.1`, dbt-bigquery `1.9`
  (`astronomer-cosmos` is unpinned in `requirements.txt` — these numbers were measured with `1.14.1`, the latest at the time of the run; reruns may pick up a newer Cosmos version.)
* **Producer pool**: 1 replica × `cpu=1 / memory=2Gi` (right-sized down from 4cpu/8Gi)
* **Consumer pool**: 9 replicas × `cpu=1 / memory=2Gi` × `worker_concurrency=2` → **18 task slots, 9 cores total**
* Airflow `parallelism=16`
* Cosmos: `watcher_dbt_execution_queue=producer`
* dbt project: `fhir-dbt-analytics` (187 models), with the `unioned_thresholds.sql` patch declaring its seed dependency

| Metric                                                                 | **LOCAL**   | **WATCHER `threads=4`**  | **WATCHER `threads=8`**  | **WATCHER `threads=12`**  | **WATCHER `threads=16`**  |
| :--------------------------------------------------------------------- | ----------: | -----------------------: | -----------------------: | ------------------------: | ------------------------: |
| **DAG wall time**                                                      | **572 s**   |                **443 s** |                **266 s** |                 **233 s** |                 **215 s** |
| Δ vs LOCAL                                                             | baseline    |                     −23% |                     −53% |                      −59% |                  **−62%** |
| Result                                                                 | ✅ 187/187  |               ✅ 188/188 |               ✅ 188/188 |                ✅ 188/188 |                ✅ 188/188 |
| Producer task duration                                                 | n/a         |                    433 s |                    252 s |                     199 s |                     163 s |
| Tail (DAG − producer)                                                  | n/a         |                     10 s |                     14 s |                      34 s |                      52 s |
| **Producer pool** (1 pod, `1cpu / 2GiB`)                               |             |                          |                          |                           |                           |
| · max CPU (cores) / % of 1 cpu                                         | n/a         |               0.25 (25%) |               0.43 (43%) |                0.66 (66%) |                0.75 (75%) |
| · total CPU (s)                                                        | n/a         |                       85 |                       92 |                       101 |                        96 |
| · peak memory (MiB) / % of 2 GiB                                       | n/a         |                918 (45%) |                952 (46%) |                 949 (46%) |                 970 (47%) |
| **Consumer pool** (9 pods × `1cpu / 2GiB`, 18 slots, 9 cores, 18 GiB)  |             |                          |                          |                           |                           |
| · max CPU summed (cores) / % of 9 cpu                                  | 4.47 (50%)  |               7.87 (87%) |               7.85 (87%) |                7.99 (89%) |                7.89 (88%) |
| · total CPU (s)                                                        | 1823        |                     1803 |                     1547 |                      1465 |                      1367 |
| · peak memory (MiB) / % of 18 GiB                                      | 9993 (54%)  |               8543 (46%) |               7988 (43%) |                8740 (47%) |                8795 (48%) |
| **Total cluster** (producer + consumer = 10 cpu, 20 GiB)               |             |                          |                          |                           |                           |
| · max CPU summed / % of 10 cpu                                         | 4.47 (45%)  |               8.06 (81%) |               8.28 (83%) |                8.63 (86%) |                8.43 (84%) |
| · total CPU (s)                                                        | 1823        |                     1888 |                     1639 |                      1566 |                  **1464** |
| · peak memory (MiB) / % of 20 GiB                                      | 9993 (49%)  |               9440 (46%) |               8932 (44%) |                9685 (47%) |                9333 (46%) |

Take-aways
----------

* WATCHER beats LOCAL at every threads value, even `threads=4` is 23% faster than LOCAL. At `threads=16` it's 2.7× faster (215 s vs 572 s).
* Both wall time and total CPU decrease monotonically with threads in WATCHER (1888 s → 1639 s → 1566 s → 1464 s of total cluster CPU). Higher threads = faster and less total CPU consumed.
* LOCAL is BigQuery-latency-bound, not CPU-bound, consumer pool tops out at only 4.47 / 9 cores (50%) even with 18 slots. Memory tells the same story: LOCAL hits 54% memory because all 16 concurrent dbt processes work concurrently in the pods, whereas WATCHER stays at 43–48% (just one `dbt build` plus light sensors).
* WATCHER fills the consumer pool to ~88% CPU, sensors do real CPU work (XCom polling, state machine), so they keep the slots busy.
* Producer at `threads=16` hits 75% of its 1-cpu cap, the next ceiling. Going past `threads=16` would benefit from producer cpu=2.

Historical results
------------------

The data printed to the console has been copied to this Google Spreadsheet:
https://docs.google.com/spreadsheets/d/10c6hMjwBJZ1DybiJT8o0TApVPyk-oPuJCY01bj2zC0A/edit?gid=0#gid=0

Checking progress mid-run
-------------------------

For long-running jobs (notably `airflow-test-dbtdag`), `progress.sh` reports how many models have been completed so far by counting `Marking task as SUCCESS` lines in the pod logs:

```
./progress.sh                                # auto-detects the airflow-test-dbtdag pod
POD=airflow-test-dbtdag-abc ./progress.sh    # use a specific pod
```

The script requires the pod to be live (`kubectl logs` against it) — it has nothing useful to say once the job has finished and `run-test.sh` has deleted it.

The script reads the dbt project's full DAG from `dbt/fhir-dbt-analytics-dbt-ls-output.json`, which is a snapshot of `dbt ls --output json` for the dbt project pinned via the submodule. The file is checked into the repo so progress.sh works without a local dbt install.

Regenerate it whenever the `dbt/fhir-dbt-analytics` submodule pin changes:

```
cd dbt/fhir-dbt-analytics
DBT_PROFILES_DIR=../../benchmark/pre-process \
KEY_PATH=../../benchmark/pre-process/key.json \
  dbt --quiet ls --output json > ../fhir-dbt-analytics-dbt-ls-output.json
```

`DBT_PROFILES_DIR` points dbt at the benchmark profile (the submodule ships with a placeholder `profiles.yml` that isn't valid YAML), and `KEY_PATH` is the env var the profile templates in. `--quiet` suppresses dbt's INFO log lines so only the JSON nodes land in the file (`progress.sh` tolerates noise lines, but a clean file is easier to diff).
