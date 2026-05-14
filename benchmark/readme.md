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

Requirements
------------

Install the following tools on the host:
* Docker (or OrbStack)
* `kind`, `kubectl`, `helm`
* `jq`, `lsof` (preinstalled on macOS; `apt-get install jq lsof` on Debian/Ubuntu)

### Host resources

The benchmark cluster runs entirely inside `kind` (one Docker container).
Allocate at minimum **10 CPU cores and 20 GiB memory** to Docker / OrbStack;
**12 CPU cores and 24 GiB memory** is recommended. This covers the
consumer workers (4 × `1cpu / 2Gi`), the dedicated WATCHER producer pool
(1 × `1cpu / 2Gi`), scheduler (`2cpu / 4Gi`), api-server / triggerer /
DAG processor / Postgres / Redis (~2 cpu / 2.5 GiB combined from chart
defaults), the Prometheus stack (~1.5 cpu / 2.5 GiB), and the kind
control plane (~1 cpu / 1 GiB).

Create a file called `key.json` inside the folder `benchmark/pre-process`, which contains the credentials to access the BigQuery instance of interest. While we are running locally, this approach is acceptable. If we are using a hosted K8s cluster, we should use K8s secrets or another more secure approach.

Update the `profiles.yml`  file in the pre-process to reference your BigQuery dataset and related Google project.

Tweaking the worker pool
------------------------

Two ways to change worker resources, replica count, or concurrency:

**Edit `pre-process/values.yml` and re-run `setup.sh`** — the script is
idempotent (`helm upgrade --install`), so it rolls out the new chart
values without recreating the cluster or rebuilding the image:

```
# bump workers from 4 → 6 replicas with 2cpu / 4Gi each
sed -i.bak \
  -e 's/replicas: 4/replicas: 6/' \
  -e 's/cpu: "1"/cpu: "2"/' \
  -e 's/memory: "2Gi"/memory: "4Gi"/' \
  benchmark/pre-process/values.yml
cd benchmark && ./setup.sh
```

**Override in place via `helm --set`** — no re-edit, no re-run of `setup.sh`:

```
helm --kube-context kind-kind upgrade airflow apache-airflow/airflow \
  --version 1.21.0 -n airflow -f benchmark/pre-process/values.yml \
  --set workers.replicas=6 \
  --set workers.resources.requests.cpu=2 --set workers.resources.limits.cpu=2 \
  --set workers.resources.requests.memory=4Gi --set workers.resources.limits.memory=4Gi \
  --set config.celery.worker_concurrency=4
```

Wait for the rollout to settle before triggering a new run:

```
kubectl --context kind-kind -n airflow rollout status deployment/airflow-worker
```

Larger worker pools may need more host headroom — see the **Host
resources** section above.

Dedicated producer worker pool (WATCHER mode)
---------------------------------------------

When the WATCHER DAG (`example_dbt_dag_watcher`) runs, Cosmos renders
one **producer** task that runs `dbt build` for the whole project plus
one sensor task per dbt model. The producer is CPU-heavy and bursty;
the sensors are meant to be lightweight — they watch the producer's
XCom, register datasets, and interact with Airflow state, but they
don't do any dbt work themselves. Running them in the same worker
pool means a single pod has to satisfy both shapes — usually badly.

`setup.sh` deploys a second worker `Deployment` (`airflow-producer-worker`)
alongside the chart's default consumer pool. The split works as follows:

* **Consumer pool** — chart-default workers (`values.yml::workers`),
  picks up the default Celery queue. Sensor tasks land here.
* **Producer pool** — rendered by `pre-process/render-producer-worker.py`
  from the chart's worker `Deployment` spec, with `component=producer-worker`
  / `cosmos-role=producer` labels and Celery args `-q producer`.
* **Routing** — `config.cosmos.watcher_dbt_execution_queue: "producer"`
  in `values.yml` makes Cosmos publish WATCHER producer tasks to the
  `producer` queue. Sensor tasks have no explicit queue, so they fall
  back to the default queue and the consumer pool.

The producer pool is env-tunable per `./setup.sh` run:

```
PRODUCER_REPLICAS=1 PRODUCER_CPU=2 PRODUCER_MEM=4Gi ./setup.sh
```

| Variable                | Default      | Notes                                                                                                                  |
| ----------------------- | ------------ | ---------------------------------------------------------------------------------------------------------------------- |
| `PRODUCER_REPLICAS`     | `1`          | One producer per DAG run is the typical shape; more replicas only help if running multiple WATCHER DAGs concurrently.  |
| `PRODUCER_CPU`          | `1`          | Matches consumer per-pod sizing. Bump for higher dbt `threads` — dbt parallelism is producer-bound.                    |
| `PRODUCER_MEM`          | `2Gi`        | Matches consumer per-pod sizing.                                                                                       |
| `PRODUCER_QUEUE`        | `producer`   | Must match `cosmos.watcher_dbt_execution_queue` in `values.yml` if you override it.                                    |
| `PRODUCER_CONCURRENCY`  | `1`          | Celery `-c` flag. Default `1` keeps each pod owning one `dbt build`; raise alongside `PRODUCER_CPU`/`PRODUCER_MEM`.    |

### Different dbt `threads` for WATCHER

Higher `threads` cuts WATCHER wall time — the producer's `dbt build`
parallelises across independent dbt models. The value lives in
`pre-process/profiles.yml` and gets baked into the image at build time —
to sweep it without rebuilding, patch the producer pod's `profiles.yml`
in place:

```
PROD=$(kubectl --context kind-kind -n airflow get pod -l cosmos-role=producer -o jsonpath='{.items[0].metadata.name}')
kubectl --context kind-kind exec -n airflow "$PROD" -c worker -- \
  sed -i 's/threads: 4/threads: 16/' /opt/airflow/profiles.yml
```

LOCAL mode ignores `threads` because each model is its own Airflow task.

Why mutate the chart's `airflow-worker` Deployment instead of writing
a manifest from scratch: keeps the producer pool inheriting
ServiceAccount / ConfigMap / Secret refs / env / volumes / init-containers
that the official chart wires up. Chart upgrades automatically flow
through to the producer pool the next time `setup.sh` runs.

Available DAGs
--------------

`benchmark/dags/cosmos_dags.py` defines the DAGs that the Helm-based
benchmark targets. Pass any subset to `run-complex-test.sh` via the
`DAGS` env var (space-separated):

* `example_dbt_dag` — Cosmos LOCAL execution mode. One Airflow task per
  dbt model in the `fhir-dbt-analytics` project.
* `example_dbt_dag_watcher` — Cosmos WATCHER execution mode. A single
  producer task runs `dbt build` for the project; per-model sensor
  tasks watch its XCom for completion. Requires Cosmos ≥ 1.11.
* `example_operator_build` — single `DbtBuildLocalOperator` task that
  runs `dbt build` on the project in one shot.

Example:

```
DAGS="example_dbt_dag_watcher" REPS=1 ./run-complex-test.sh
```

Per-pool metrics
----------------

After each rep, `run-complex-test.sh` invokes
`post-process/report-dag-run-pool-metrics.sh`, which queries Prometheus
(via the `localhost:9090` port-forward) for:

* **Producer pool** — pods matching `airflow-producer-worker-.+`
* **Consumer pool** — pods matching `airflow-worker-.+`
* **Total cluster** — both pools combined

Each query is scoped to the actual DAG-run window pulled from Airflow's
metadata (`start_date`, `end_date`), so historical pod incarnations from
earlier reps don't pollute the totals. Per pool the script reports:

* Max CPU utilisation (cores, summed across the pool)
* Total CPU seconds consumed
* Peak memory working-set (bytes, formatted as MiB / GiB)

Optional env vars on `report-dag-run-pool-metrics.sh`:

* `METRICS_CSV=/path/to/file.csv` — append a one-line CSV row per rep,
  writing a header on first append. Use this for sweeps where the
  results need to land in a spreadsheet.
* `BENCH_LABEL="..."` — free-form label baked into the CSV row (e.g.
  `LOCAL`, `WATCHER threads=8`). Empty if unset.

Example — 5 reps of WATCHER at `threads=8`, CSV piped into one file:

```
METRICS_CSV=/tmp/results.csv BENCH_LABEL="WATCHER threads=8" \
  DAGS="example_dbt_dag_watcher" REPS=5 ./run-complex-test.sh
```

Upstream dbt project patches
----------------------------

The benchmark Docker image overlays files from `benchmark/patches/` onto
the upstream `fhir-dbt-analytics` dbt project at build time (see the
`COPY ... /opt/airflow/models/...` lines in `benchmark/Dockerfile`).
Each patch fixes a specific issue that causes flaky benchmark failures;
the patch file itself documents the rationale in a leading Jinja
comment block.

Current patches:

* `unioned_thresholds.sql` — adds an explicit `depends_on:
  {{ ref('thresholds') }}` hint so dbt's scheduler waits for the
  `thresholds` seed before recreating the view. Upstream uses an
  `adapter.get_relation(...)` lookup that dbt's static analysis can't
  see, which leaves the seed→view edge missing from the DAG and races
  at `threads ≥ 8`.

Analysing performance
---------------------

> **Note:** the flow below is the **legacy kubectl-Job-based** benchmark path, kept here for reference. The Helm-based flow documented above is canonical for LOCAL vs WATCHER comparisons.

As a first step, we'll analyse dbt-core commands performance.
This approach will be extended to run Airflow.

To run this analysis, run the following scripts:

1. Firstly, run the pre-process, by running:

```
./setup.sh
```

This command will
- create a K8s cluster with Kind
- build the docker image with dbt Core, the dbt project and credentials to access the Data Warehouse
- make the docker image available to the K8s cluster
- install Prometheus in the cluster, so we can fetch metrics
- expose Prometheus in the host via port 9090

2. Second, run the experiments of interest by running:

```
./run-test.sh
```

Each experiment is defined as K8s jobs in the folder `experiment`. These are the jobs available:
- dbt-core-build: Runs `dbt build` against `fhir-dbt-analytics`
- dbt-core-run: Run the `dbt run` command against the dbt project `fhir-dbt-analytics`
- dbt-core-seed: Run the `dbt seed` command against the dbt project `fhir-dbt-analytics`
- dbt-core-test: Run the `dbt test` command against the dbt project `fhir-dbt-analytics`
- dbt-core-run-per-model: Run sequential `dbt run` commands for each model of the project dbt project `fhir-dbt-analytics` (185 models)
- airflow-test-dbtdag: Run `airflow dags test` against a Cosmos `DbtDag` that creates one individual Airflow task per dbt model
- airflow-test-buildoperator: Run `airflow dags test` using a DAG that instantiates Cosmos' `DbtBuildLocalOperator` and runs the dbt project `fhir-dbt-analytics` using a single Airflow task

By default, the job `dbt-core-run-per-model` is run.

By default, each selected experiment will be run 3 times.

For each experiment, the following steps are completed:
- create a K8s job
- execute the K8s job in the Kind cluster
- collect the metrics for that job
- delete the job

The experiments run and the amount of repetitions can be configured by setting environment variables via command line, as illustrated below:
```
JOBS="dbt-core-build dbt-core-run" REPS=3 ./run-test.sh
```

3. The collected metrics are printed in the terminal, example:

```
=== Run #1 for dbt-core-build ===
Start time: 2025-10-07T03:33:24-0700
job.batch "dbt-core-build" deleted
job.batch/dbt-core-build created
job.batch/dbt-core-build condition met
End time: 2025-10-07T03:38:10-0700
Fetching metrics for pod: dbt-core-build-54h4q

Metrics for Pod: dbt-core-build-54h4q (last 240h)
----------------------------------------------
Max CPU Utilization (cores):    0.13957793105490057
Stddev CPU Utilization (cores): 0.02129759725801408
Max Memory Usage:     402 MiB
Stddev Memory Usage:  83 MiB
Job Duration: 00:04:44
job.batch "dbt-core-build" deleted

3. To delete the cluster, once you finished running the tests:

```
./teardown.sh
```

Results
-------

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
