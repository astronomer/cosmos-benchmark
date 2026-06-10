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

Pinning the astronomer-cosmos version
-------------------------------------

The benchmark image installs `astronomer-cosmos` via a Dockerfile build-arg
(`COSMOS_VERSION`, default `1.14.2`). `setup.sh` threads two env vars through
to the build + helm install so you can pin a specific Cosmos release without
editing files:

* `COSMOS_VERSION` — passed to `docker build --build-arg`; e.g. `1.13.1`.
* `IMAGE_TAG` — image tag used by `docker build`, `kind load`, and the chart's
  `images.airflow.tag`. Defaults to `0.0.7` (matches `pre-process/values.yml`).

```
COSMOS_VERSION=1.13.1 IMAGE_TAG=cosmos-1.13.1 ./setup.sh
```

Always pick a non-default `IMAGE_TAG` when you change `COSMOS_VERSION` —
Kubernetes won't re-pull a tag it has cached, so reusing `0.0.7` between
Cosmos versions would leave the cluster running the previously-loaded image.
Sweeping multiple Cosmos versions in one cluster lifecycle is automated by
`benchmark/remote/run-sweep.sh` (see _Running benchmarks remotely on GCP_).

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
* `synthetic_watcher_{1,5,10,13}tg` — WATCHER DAGs over the
  `synthetic_large_dbt_project`, each with N Cosmos task groups (1/5/10/13).
  Used to measure how WATCHER **sensor** memory scales with task-group count
  (see *WATCHER sensor memory vs. task groups* below).

Example:

```
DAGS="example_dbt_dag_watcher" REPS=1 ./run-complex-test.sh
```

WATCHER sensor memory vs. task groups
------------------------------------------------

Characterising how WATCHER per-sensor RSS scales with project size, at large
manifest scale (manifest <20 MiB but >23,000 nodes).

**Mechanism.** In WATCHER mode every sensor task re-imports the DAG on its
worker at startup, which instantiates *every* `DbtTaskGroup` in the file — and
each group does a full manifest parse + graph build (it loads all nodes, then
filters to its `select`). So per-sensor peak RSS grows linearly with the
**number of task groups** and with **manifest size**, even though the sensor
runs no dbt. Memory is measured per task with Cosmos debug mode
(`AIRFLOW__COSMOS__ENABLE_DEBUG_MODE=True` → `cosmos_debug_max_memory_mb` XCom +
the `Max memory usage (RSS, incl. children)` log line).

**Measured** (per-sensor peak RSS, MB):

| Manifest (`N_MODELS`) | 1 group | 5 groups | 10 groups | 13 groups | slope        |
| --------------------- | ------- | -------- | --------- | --------- | ------------ |
| 3,000                 | 322     | 380      | 424       | —         | 11.3 MB/grp  |
| 23,000                | 486     | 865      | 1295      | 1555      | 88.7 MB/grp  |

The 23k line is `RSS ≈ 407 + 88.7·groups` (R²=0.9995). **23k × 13 groups ≈
1.55 GB** at the large-manifest scale. The per-group slope scales with
manifest size (88.7/11.3 ≈ 7.85 ≈ node ratio 23k/3k). Per-sensor RSS is
**independent of sensors-per-group** (1 group × 250 nodes = 1 group × 25 nodes
= 322 MB), confirming task-group *count* is the driver.

**Mitigation for large projects:** fewer task groups. On a 23k-node manifest
each group adds ~89 MB/sensor, so consolidating 13 → 4 groups saves ~800
MB/sensor. (Deeper fix is upstream in Cosmos: parse the manifest once and share
the graph across groups instead of re-parsing per group per task.)

**Reproducing.** The synthetic project is generated deterministically, so node
count is a build knob — build the image at the desired scale, then run the DAGs:

```
# 23k-node manifest (large scale); default N_MODELS is 3000
docker build -t benchmark:0.0.7 --build-arg N_MODELS=23000 -f benchmark/Dockerfile .
kind load --name kind docker-image benchmark:0.0.7
# ... helm upgrade / rollout restart to pick up the image ...

# Seed once so raw-layer views build (raw models ref only seed_dim):
PROD=$(kubectl --context kind-kind -n airflow get pod -l cosmos-role=producer -o jsonpath='{.items[0].metadata.name}')
kubectl --context kind-kind exec -n airflow "$PROD" -c worker -- bash -lc \
  'cd /opt/airflow/dbt/synthetic_large_dbt_project && dbt seed --profiles-dir . --project-dir .'

DAGS="synthetic_watcher_1tg synthetic_watcher_13tg" REPS=1 ./run-complex-test.sh
```

Collect per-sensor RSS from the `cosmos_debug_max_memory_mb` XComs (one per
`*_run` sensor task; exclude the `*producer*` tasks).

> **Note — fragility at scale.** At 23k nodes the WATCHER **producer** (which
> also re-parses the manifest per group at import, plus dbt's own parse) rides
> the memory limit and intermittently process-OOMs (empty-log SIGKILL); a dead
> producer fails its whole sensor group. Getting clean sensor readings at 23k
> required a single sequential worker (`workers.replicas=1`,
> `worker_concurrency=1`) and a larger producer pool (`PRODUCER_MEM=8Gi`). This
> is consistent with sensor flakiness at `worker_concurrency=2`.

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

Once a sweep is finished, `post-process/summarise-metrics.py` reads
the CSV and emits a markdown table with `mean ± sample-stdev` (n−1
denominator) per `(config, metric)`, ready to paste into the results
section below:

```
./post-process/summarise-metrics.py /tmp/results.csv \
  --label-order "LOCAL,WATCHER threads=4,WATCHER threads=8,WATCHER threads=12,WATCHER threads=16"
```

The script is stdlib-only (no `pandas` dependency); memory cells are
converted from raw bytes to MiB before averaging so the table matches
the units in the per-rep stdout report.

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

Results: LOCAL vs WATCHER (2026-05-15)
======================================

5-rep sweep with the configuration the cluster was sized for (9 consumer
replicas, 1 producer, `parallelism=16`). Raw per-rep CSV lives in the
[team Google Sheet](https://docs.google.com/spreadsheets/d/10c6hMjwBJZ1DybiJT8o0TApVPyk-oPuJCY01bj2zC0A/edit?gid=0#gid=0)
under the `2026-05-15` tab. Cells below are `mean ± sample-stdev (n=5)`,
generated by `post-process/summarise-metrics.py`.

Cluster config (identical for every column):

* Apache Airflow Helm chart `1.21.0` (Airflow `3.2.0`), `astronomer-cosmos==1.14.1`,
  `dbt-bigquery==1.9`, dbt project `fhir-dbt-analytics` with the
  `unioned_thresholds.sql` overlay
* **Producer pool:** 1 replica × `cpu=1 / memory=2Gi`, `PRODUCER_CONCURRENCY=1`
* **Consumer pool:** 9 replicas × `cpu=1 / memory=2Gi` × `worker_concurrency=2`
  → 18 task slots / 9 cores total
* Airflow `parallelism=16`
* Cosmos `watcher_dbt_execution_queue=producer` routing

| Metric | LOCAL | WATCHER threads=4 | WATCHER threads=8 | WATCHER threads=12 | WATCHER threads=16 |
| --- | --- | --- | --- | --- | --- |
| Wall time (s) | 532 ± 13 (n=5) | 450 ± 10 (n=5) | 314 ± 9 (n=5) | 337 ± 70 (n=5) | 313 ± 15 (n=5) |
| Tasks succeeded / total | 187/187 (5/5 ✅) | 188/188 (5/5 ✅) | 188/188 (5/5 ✅) | 188/188 (5/5 ✅) | 188/188 (5/5 ✅) |
| Producer task duration (s) | — | 436 ± 11 (n=5) | 253 ± 4 (n=5) | 256 ± 104 (n=5) | 186 ± 2 (n=5) |
| Tail (DAG − producer, s) | — | 13 ± 2 (n=5) | 61 ± 6 (n=5) | 81 ± 42 (n=5) | 126 ± 14 (n=5) |
| Producer max CPU (cores) | 0.05 ± 0.01 (n=5) | 0.28 ± 0.03 (n=5) | 0.54 ± 0.02 (n=5) | 0.70 ± 0.03 (n=5) | 0.83 ± 0.02 (n=5) |
| Producer total CPU (s) | 16 ± 1 (n=5) | 96 ± 7 (n=5) | 118 ± 2 (n=5) | 122 ± 3 (n=5) | 124 ± 2 (n=5) |
| Producer peak mem (MiB) | 459 ± 24 (n=5) | 809 ± 7 (n=5) | 826 ± 6 (n=5) | 857 ± 13 (n=5) | 859 ± 14 (n=5) |
| Consumer max CPU (cores) | 4.30 ± 0.40 (n=5) | 7.96 ± 0.15 (n=5) | 8.05 ± 0.10 (n=5) | 8.15 ± 0.16 (n=5) | 8.30 ± 0.08 (n=5) |
| Consumer total CPU (s) | 1872 ± 75 (n=5) | 2019 ± 208 (n=5) | 2142 ± 68 (n=5) | 2120 ± 215 (n=5) | 2137 ± 136 (n=5) |
| Consumer peak mem (MiB) | 10221 ± 125 (n=5) | 8329 ± 313 (n=5) | 8680 ± 130 (n=5) | 8864 ± 185 (n=5) | 8813 ± 359 (n=5) |
| Total max CPU (cores) | 4.33 ± 0.42 (n=5) | 8.22 ± 0.17 (n=5) | 8.46 ± 0.08 (n=5) | 8.64 ± 0.05 (n=5) | 8.73 ± 0.16 (n=5) |
| Total CPU (s) | 1887 ± 76 (n=5) | 2115 ± 215 (n=5) | 2260 ± 67 (n=5) | 2243 ± 217 (n=5) | 2261 ± 136 (n=5) |
| Total peak mem (MiB) | 10645 ± 122 (n=5) | 9115 ± 308 (n=5) | 9484 ± 145 (n=5) | 9480 ± 182 (n=5) | 9573 ± 455 (n=5) |

Take-aways
----------

* **WATCHER beats LOCAL at every threads value.** Even at `threads=4`,
  WATCHER is 15% faster than LOCAL (450 s vs 532 s). At `threads=8` and
  `threads=16` it's 41% faster.
* **`threads=8` is the sweet spot in this run.** Going past 8 doesn't
  help wall time — producer task duration keeps dropping (253 s → 186 s
  from t=8 → t=16) but the sensor "tail" grows almost in lockstep
  (61 s → 126 s), so the savings are mostly cancelled.
* **The tail grew significantly vs the 2026-05-08 baseline** (prior
  benchmark that was not committed to the commit history but can be found in PR #25).
  At `threads=8` we measured `61 ± 6 s` vs `14 s` previously; at `threads=16`, `126 ± 14 s` vs `52 s`.
  Producer durations track the prior numbers closely, so the divergence
  is in the WATCHER sensor wake-up / XCom polling path — likely a
  function of the Airflow 3.2 scheduler behaviour. Tracked in
  [astronomer/astronomer-cosmos#2657](https://github.com/astronomer/astronomer-cosmos/issues/2657).
* **LOCAL is BigQuery-latency-bound, not CPU-bound** — consumer pool
  tops out at `4.30 / 9 = 48%` CPU even with 18 task slots. Memory tells
  the same story: LOCAL peaks at 10.2 GiB because 16 concurrent dbt
  processes are alive at once, while WATCHER stays at ~8.6 GiB
  (one `dbt build` plus light sensors).
* **WATCHER consumer pool fills to ~90% CPU** (7.96–8.30 cores out of 9).
  Sensors do real Airflow-side work — XCom reads, dataset registration,
  state updates — so they keep the consumer slots busy.
* **Rep 5 of `threads=12` was an outlier** (producer 441 s vs ~210 s for
  reps 1–4) — kept in the dataset; treat the wide stdev on that column
  with caution.

Reproducing the 2026-05-15 sweep
--------------------------------

Starting from a working benchmark cluster (`./setup.sh` from main with
all PRs in this stack merged, OrbStack allocated ≥ 14 cpu / 28 GiB),
**run all the commands below from inside the `benchmark/` directory**
(where `setup.sh`, `run-complex-test.sh`, and the `post-process/` and
`pre-process/` folders all live).

Scale the consumer pool from the default 4 → 9 replicas:

```
helm --kube-context kind-kind upgrade airflow apache-airflow/airflow --version 1.21.0 \
  -n airflow -f pre-process/values.yml \
  --set workers.replicas=9
kubectl --context kind-kind -n airflow rollout status deployment/airflow-worker
```

Run each config in turn, all writing into the same CSV (header on file
creation; subsequent runs append):

```
# Config 1/5: LOCAL × 5 reps
METRICS_CSV=/tmp/sweep-2026-05-15.csv BENCH_LABEL="LOCAL" \
  DAGS="example_dbt_dag" REPS=5 ./run-complex-test.sh
sleep 60

# Config 2/5: WATCHER threads=4 (producer pod's profiles.yml ships at threads=4)
METRICS_CSV=/tmp/sweep-2026-05-15.csv BENCH_LABEL="WATCHER threads=4" \
  DAGS="example_dbt_dag_watcher" REPS=5 ./run-complex-test.sh
sleep 60

# Bump dbt threads in the producer pod between WATCHER configs (no image rebuild)
PROD=$(kubectl --context kind-kind -n airflow get pod -l cosmos-role=producer -o jsonpath='{.items[0].metadata.name}')
kubectl --context kind-kind exec -n airflow "$PROD" -c worker -- sed -i 's/threads: 4/threads: 8/' /opt/airflow/profiles.yml

# Config 3/5
METRICS_CSV=/tmp/sweep-2026-05-15.csv BENCH_LABEL="WATCHER threads=8" \
  DAGS="example_dbt_dag_watcher" REPS=5 ./run-complex-test.sh
sleep 60

kubectl --context kind-kind exec -n airflow "$PROD" -c worker -- sed -i 's/threads: 8/threads: 12/' /opt/airflow/profiles.yml

# Config 4/5
METRICS_CSV=/tmp/sweep-2026-05-15.csv BENCH_LABEL="WATCHER threads=12" \
  DAGS="example_dbt_dag_watcher" REPS=5 ./run-complex-test.sh
sleep 60

kubectl --context kind-kind exec -n airflow "$PROD" -c worker -- sed -i 's/threads: 12/threads: 16/' /opt/airflow/profiles.yml

# Config 5/5
METRICS_CSV=/tmp/sweep-2026-05-15.csv BENCH_LABEL="WATCHER threads=16" \
  DAGS="example_dbt_dag_watcher" REPS=5 ./run-complex-test.sh
```

Generate the summary table from the accumulated CSV:

```
./post-process/summarise-metrics.py /tmp/sweep-2026-05-15.csv \
  --label-order "LOCAL,WATCHER threads=4,WATCHER threads=8,WATCHER threads=12,WATCHER threads=16"
```

The full sweep takes ~2.8 hours on a single-node kind cluster sized at
14 cpu / 28 GiB.

Running benchmarks remotely on GCP
==================================

For fully isolated, repeatable comparisons — same Linux kernel, same VM
shape, no contention with whatever's running on your laptop —
`benchmark/remote/` ships a small set of scripts that provision a GCE VM,
drive a Cosmos-version × dbt-threads sweep on it, and pull the resulting
CSV back. The on-VM driver reuses `setup.sh` + `run-complex-test.sh` + the
`post-process/` scripts unchanged; the only novel logic is iterating the
matrix and rebuilding the benchmark image between Cosmos versions.

Prerequisites on the laptop:

* `gcloud` CLI authenticated (`gcloud auth login`), default project
  `astronomer-dag-authoring` — or override with `GCP_PROJECT`.
* Keyless BigQuery auth — **no `key.json` needed for the remote sweep.** The VM
  is created with a service account attached (`SA_EMAIL`) and dbt uses
  Application Default Credentials off the GCE metadata server; nothing is
  uploaded to instance metadata or baked into the image. The SA needs BigQuery
  Job User + Data Viewer on the benchmark dataset, and the operator needs
  `iam.serviceAccounts.actAs` on it. See `remote/readme.md` for the one-time
  setup.

Default sweep:

```
cd benchmark/remote
./provision.sh           # creates the VM and kicks off the sweep
./monitor.sh             # tails the on-VM sweep log (optional, Ctrl-C is safe)
./fetch-results.sh       # blocks until SWEEP_DONE, then scps CSV + .md into ../results/
./teardown.sh            # deletes the VM and its boot disk
```

Defaults: `n2-standard-16` (16 vCPU / 64 GiB) in `us-central1-a`, 100 GiB
pd-ssd, sweep matrix `COSMOS_VERSIONS="1.13.1 1.14.2"` ×
`THREADS_VALUES="4 8 16"` × `REPS=5`. The default sweep takes ~3 hrs of VM
wall time (≈ $2.35 at on-demand pricing). `teardown.sh` removes both the VM
and its disk; nothing else lingers in the project.

16 vCPU is needed to fit the 9-consumer + 1-producer worker pool used by the
2026-05-15 baseline config: 9 consumers × 1 cpu + 1 producer × 1 cpu +
scheduler 2 cpu + ~1.2 cpu of chart/monitoring overhead ≈ 13.2 cpu of
*reservations*, which over-subscribes a 12-vCPU node (2 workers stay
`Pending` with `Insufficient cpu`). If you shrink `workers.replicas`, a
12-vCPU machine (`n2-custom-12-49152`, ~$0.58/hr) is enough.

Override via env vars on `provision.sh`:

| Var               | Default                       | Notes |
| ----------------- | ----------------------------- | ----- |
| `GCP_PROJECT`     | `astronomer-dag-authoring`    | Used for both billing and BigQuery. |
| `GCP_ZONE`        | `us-central1-a`               |       |
| `VM_NAME`         | `cosmos-bench`                |       |
| `MACHINE_TYPE`    | `n2-standard-16`              | 16 vCPU / 64 GiB — sized to fit the 9-consumer + 1-producer pool (see above). Drop to `n2-custom-12-49152` (M4-Pro-comparable) if you also shrink `workers.replicas`. |
| `DISK_SIZE_GB`    | `100`                         | pd-ssd. Images + kind data + Prometheus storage fit comfortably under 50 GiB. |
| `COSMOS_VERSIONS` | `1.13.1 1.14.2`               | Space-separated; first version is also the one `setup.sh` deploys initially. |
| `THREADS_VALUES`  | `4 8 16`                      | Space-separated. Patched into the producer pod's `profiles.yml` between cells. |
| `REPS`            | `5`                           | Reps per `(cosmos, threads)` cell. |
| `AIRFLOW_BASE`    | `apache/airflow:3.2.0`        | Dockerfile `FROM` image. Must be a matched pair with `CHART_VERSION` — chart appVersion === image tag. |
| `CHART_VERSION`   | `1.21.0`                      | apache-airflow Helm chart version. `1.21.0` → Airflow 3.2.0, `1.20.0` → Airflow 3.1.8, `1.19.0` → Airflow 3.1.7. |
| `REPO_URL`        | upstream cosmos-benchmark repo | Useful when forking. |
| `REPO_BRANCH`     | `main`                        | Point at a feature branch when iterating on the remote scripts themselves. |

`monitor.sh`, `fetch-results.sh`, and `teardown.sh` share the same
`GCP_PROJECT`, `GCP_ZONE`, and `VM_NAME` env vars; if you override one on
`provision.sh`, override it on the others too.

### Cosmos version × Airflow version compatibility

`astronomer-cosmos` releases before `1.14.0` have a top-level
`from airflow.configuration import conf` in `cosmos/settings.py`. Airflow
3.2 changed config init to eagerly enumerate providers (including Cosmos),
which makes that import circular — every Airflow pod CrashLoopBackOff's
with `ImportError: cannot import name 'conf' from partially initialized
module 'airflow.configuration'`. Symptom in `kubectl get pods -n airflow`:
the `airflow-run-airflow-migrations` Job hits BackoffLimitExceeded and
every other pod sits in `Init:CrashLoopBackOff` on `wait-for-airflow-migrations`.

To sweep a Cosmos version that pre-dates 1.14 (e.g. comparing 1.13.1 vs
1.14.2 for a regression investigation), drop the cluster to Airflow 3.1.x
by setting **both** `AIRFLOW_BASE` and `CHART_VERSION` to a matched pair:

```
AIRFLOW_BASE=apache/airflow:3.1.8 CHART_VERSION=1.20.0 \
COSMOS_VERSIONS="1.13.1 1.14.2" \
  ./provision.sh
```

Airflow 3.1 doesn't have the eager-provider-config-init path, so Cosmos
1.13.x imports cleanly. Note this means the resulting numbers aren't
directly comparable to the published 2026-05-15 LOCAL-vs-WATCHER table
(which was on Airflow 3.2 + chart 1.21.0).

### Worked example: Cosmos 1.13.1 vs 1.14.2 in WATCHER mode

End-to-end recipe for the comparison this remote harness was built for —
WATCHER execution mode, both Cosmos versions, across dbt `threads`
{4, 8, 16}, 5 reps each (30 DAG runs total, ~3 hrs on `n2-standard-16`).
Run everything from `benchmark/remote/`:

```
# 1. Provision the VM and kick off the full sweep. The four overrides:
#    - AIRFLOW_BASE + CHART_VERSION: drop to Airflow 3.1.8 so Cosmos 1.13.1
#      imports cleanly (see the compatibility note above).
#    - COSMOS_VERSIONS: the two versions to compare.
#    - THREADS_VALUES / REPS: the sweep matrix.
AIRFLOW_BASE=apache/airflow:3.1.8 CHART_VERSION=1.20.0 \
COSMOS_VERSIONS="1.13.1 1.14.2" THREADS_VALUES="4 8 16" REPS=5 \
  ./provision.sh

# 2. Watch progress (optional; Ctrl-C just disconnects, sweep keeps running).
./monitor.sh

# 3. Once the sweep prints "SWEEP DONE", pull the CSV + summary table into
#    ../results/ (blocks on the SWEEP_DONE sentinel by default).
./fetch-results.sh

# 4. Delete the VM and its disk.
./teardown.sh
```

For a quick pipeline smoke-test before committing to the 3-hr run, shrink
the matrix to one cell: `THREADS_VALUES="8" REPS=1` (~30 min, ~$0.40).

The summary table is generated by `post-process/summarise-metrics.py` and
reports `mean ± sample-stdev` per `(cosmos version, threads)` cell for wall
time, producer task duration, the sensor "tail", and per-pool CPU / memory
— the three dimensions the comparison targets (execution time, CPU, memory).

**Iterate faster:** image-level changes (Dockerfile, dependency pins) can be
validated locally without a VM —
`docker build --build-arg AIRFLOW_BASE=apache/airflow:3.1.8 --build-arg COSMOS_VERSION=1.13.1 -f benchmark/Dockerfile .`
catches build/dependency failures in minutes. Only cluster-level behaviour
(helm install, worker scheduling, the benchmark itself) needs the GCE VM.

Results: Cosmos 1.13.1 vs 1.14.2 WATCHER (2026-06-01)
=====================================================

First remote (GCE) sweep, comparing `astronomer-cosmos` **1.13.1 vs 1.14.2**
in WATCHER mode. Raw per-rep CSV is in the
[team Google Sheet](https://docs.google.com/spreadsheets/d/10c6hMjwBJZ1DybiJT8o0TApVPyk-oPuJCY01bj2zC0A/edit?gid=0#gid=0)
under the `2026-06-01 Benchmark 1.13.1 & 1.14.2 on Cloud VM` tab. Cells below
are `mean ± sample-stdev (n=5)` from `post-process/summarise-metrics.py`.

Cluster config (identical for every column):

* GCE `n2-standard-16` (16 vCPU / 64 GiB), single-node `kind`, Prometheus
  scrape 5s, boot disk pd-ssd
* Apache Airflow **3.1.8** (Helm chart `1.20.0`) — *not* 3.2.x, because
  Cosmos 1.13.1 has a circular import under Airflow 3.2 (see the
  compatibility note above)
* `dbt-bigquery==1.9`, dbt project `fhir-dbt-analytics` (~185 models / 188
  nodes) with the `unioned_thresholds.sql` overlay, `protobuf>=6` pin
* **Producer pool:** 1 × `cpu=1 / memory=2Gi`, `PRODUCER_CONCURRENCY=1`
* **Consumer pool:** 9 × `cpu=1 / memory=2Gi` × `worker_concurrency=2`
* Airflow `parallelism=16`, Cosmos `watcher_dbt_execution_queue=producer`
* Only difference between the two halves: `astronomer-cosmos` 1.13.1 vs 1.14.2

| Metric | 1.13.1 t=4 | 1.13.1 t=8 | 1.13.1 t=16 | 1.14.2 t=4 | 1.14.2 t=8 | 1.14.2 t=16 |
| --- | --- | --- | --- | --- | --- | --- |
| Wall time (s) | 525 ± 24 | 523 ± 26 | 527 ± 13 | 415 ± 22 | 383 ± 18 | 394 ± 15 |
| Tasks succeeded / total | min 187/188 (3/5 ✅) | min 187/188 (3/5 ✅) | min 187/188 (2/5 ✅) | 188/188 (5/5 ✅) | 188/188 (5/5 ✅) | 188/188 (5/5 ✅) |
| Producer task duration (s) | 487 ± 70 | 494 ± 58 | 476 ± 56 | 379 ± 29 | 296 ± 4 | 290 ± 4 |
| Tail (DAG − producer, s) | 38 ± 49 | 29 ± 38 | 51 ± 45 | 36 ± 20 | 87 ± 18 | 104 ± 13 |
| Producer max CPU (cores) | 0.27 ± 0.03 | 0.26 ± 0.04 | 0.24 ± 0.02 | 0.80 ± 0.01 | 0.98 ± 0.00 | 0.99 ± 0.00 |
| Producer total CPU (s) | 79 ± 3 | 80 ± 5 | 83 ± 3 | 271 ± 11 | 269 ± 3 | 269 ± 4 |
| Producer peak mem (MiB) | 610 ± 118 | 770 ± 118 | 662 ± 144 | 939 ± 5 | 922 ± 40 | 903 ± 38 |
| Consumer total CPU (s) | 3930 ± 28 | 3981 ± 157 | 4018 ± 84 | 3010 ± 143 | 2812 ± 137 | 2921 ± 120 |
| Consumer peak mem (MiB) | 11349 ± 295 | 11681 ± 259 | 11832 ± 234 | 8832 ± 212 | 8846 ± 233 | 9047 ± 231 |
| Total CPU (s) | 4009 ± 28 | 4061 ± 159 | 4101 ± 87 | 3280 ± 146 | 3082 ± 139 | 3191 ± 121 |
| Total peak mem (MiB) | 11906 ± 296 | 12239 ± 259 | 12389 ± 234 | 9656 ± 211 | 9672 ± 270 | 9804 ± 256 |

Take-aways
----------

* **At this scale (~185 models), 1.14.2 is ~21-27% faster, ~18-24% lower total
  CPU, and ~19-21% lower peak memory than 1.13.1** at every thread count.

* **1.14.2 parallelizes the producer `dbt build`; 1.13.1 does not.** 1.13.1's
  producer is pinned at ~0.25 cores and ~485 s regardless of `threads` (4 / 8 /
  16 all identical). 1.14.2's producer scales — 379 → 296 → 290 s, 0.80 → 0.98
  → 0.99 cores — and dbt confirms `Concurrency: 4/8/16 threads` in its logs.
  This producer improvement is the source of 1.14.2's win here.

* **The WATCHER "tail" grows in 1.14.2 (36 → 87 → 104 s vs 1.13.1's ~29-51 s).**
  This is the per-node XCom-push + Variable-backup overhead introduced in
  1.14.x ([astronomer-cosmos#2736](https://github.com/astronomer/astronomer-cosmos/issues/2736)):
  1.13.1 pushed one combined XCom at the end of the build, 1.14.x pushes one
  XCom **per node** (plus a Variable backup) via the `NodeFinished` callback.
  At 188 nodes on a fast single-node cluster the tail is tens of seconds and
  the producer speedup dominates, so 1.14.2 nets faster.

* **This does NOT contradict the >3× regression reported in #2736 — it's the
  same mechanism at a different scale.** #2736 is 809 models / 3201 nodes on
  self-hosted Kubernetes with etcd on HDD, where each XCom + Variable write
  costs 150-400 ms and floods the API server with 500s. There the per-node
  tail overhead (~16 min+) dwarfs the producer speedup and the DAG times out.
  Our benchmark reproduces the *tail-growth trend* but is too small / too fast
  to reproduce the catastrophic regression. **To reproduce #2736 here we'd need
  a much larger dbt project (500-800+ models) and/or a slower / contended XCom
  backend** — see "Reproducing #2736" below.

* **Reliability:** 1.14.2 hit 188/188 on all 15 reps; 1.13.1 intermittently
  dropped to 187/188 (one flaky `fhir-dbt-analytics` model). Worth checking
  whether the submodule pin predates the upstream fix for that model.

Reproducing #2736 (next step, not yet run)
------------------------------------------

The 2026-06-01 sweep shows 1.14.2 *winning* at ~185 models — the opposite of
the production regression — because the per-node XCom tail hasn't yet overtaken
the producer-parallelism gain. To surface the regression on this harness:

* **Scale the dbt project up** to ~500-800+ models (the regression is roughly
  linear in node count × per-write latency), and/or
* **Slow the XCom/Variable backend** to mimic etcd-on-HDD (the benchmark uses
  a local Postgres metadata DB on pd-ssd, ~1-2 orders of magnitude faster than
  the #2736 infra), and/or
* Watch the **tail** column specifically — it already trends the right way
  (grows with both node count and threads); a larger project should make it
  cross over and dominate wall time.

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
