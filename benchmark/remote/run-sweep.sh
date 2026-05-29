#!/usr/bin/env bash
#
# Cosmos-version × threads sweep driver. Runs on the GCE VM, kicked off by
# bootstrap.sh after Docker/kind/kubectl/helm are installed. Reuses the
# existing setup.sh + run-complex-test.sh + post-process scripts; the only
# novel logic here is iterating the (cosmos_version, threads) matrix and
# rebuilding/redeploying the benchmark image between Cosmos versions.
#
# Inputs (exported by bootstrap.sh from instance metadata):
#   COSMOS_VERSIONS   space-separated list (e.g. "1.13.1 1.14.2")
#   THREADS_VALUES    space-separated list (e.g. "4 8 16")
#   REPS              integer reps per (cosmos, threads) cell
#   AIRFLOW_BASE      Dockerfile FROM image (e.g. apache/airflow:3.1.8)
#   CHART_VERSION     apache-airflow Helm chart version (e.g. 1.20.0)
#
# Outputs (under /opt/cosmos-bench/results/):
#   sweep-<timestamp>.csv   raw per-rep metrics (RFC 4180 CSV)
#   sweep-<timestamp>.md    summary table from summarise-metrics.py
#   sweep-latest.csv|.md    symlinks to the most recent sweep
#   SWEEP_DONE              sentinel touched once the sweep finishes cleanly
#
# fetch-results.sh on the laptop polls for SWEEP_DONE and scps the symlinks.

set -euxo pipefail

: "${COSMOS_VERSIONS:?must be set by bootstrap.sh}"
: "${THREADS_VALUES:?must be set by bootstrap.sh}"
: "${REPS:?must be set by bootstrap.sh}"
: "${AIRFLOW_BASE:?must be set by bootstrap.sh}"
: "${CHART_VERSION:?must be set by bootstrap.sh}"

REPO_ROOT="/opt/cosmos-bench/cosmos-benchmark"
RESULTS_DIR="/opt/cosmos-bench/results"
SENTINEL="${RESULTS_DIR}/SWEEP_DONE"

mkdir -p "$RESULTS_DIR"
rm -f "$SENTINEL"
TS="$(date +%Y%m%d-%H%M%S)"
SWEEP_CSV="${RESULTS_DIR}/sweep-${TS}.csv"
SWEEP_MD="${RESULTS_DIR}/sweep-${TS}.md"

read -ra VERSIONS <<<"$COSMOS_VERSIONS"
read -ra THREADS  <<<"$THREADS_VALUES"
FIRST_VERSION="${VERSIONS[0]}"

cd "${REPO_ROOT}/benchmark"

# --- Initial provisioning ----------------------------------------------------
# setup.sh creates the kind cluster, installs Prometheus + Airflow, builds the
# benchmark image, and deploys the producer worker pool. We pass COSMOS_VERSION
# + IMAGE_TAG + AIRFLOW_BASE + CHART_VERSION so the very first deployment is
# already on cosmos=FIRST_VERSION; subsequent versions get a fresh build + helm
# upgrade below.
COSMOS_VERSION="$FIRST_VERSION" \
IMAGE_TAG="cosmos-${FIRST_VERSION}" \
AIRFLOW_BASE="$AIRFLOW_BASE" \
CHART_VERSION="$CHART_VERSION" \
  ./setup.sh

# Scale consumer pool to the 2026-05-15 published config (9 replicas) so this
# sweep is comparable to the LOCAL-vs-WATCHER table in benchmark/readme.md.
helm --kube-context kind-kind upgrade airflow apache-airflow/airflow \
  --version "${CHART_VERSION}" -n airflow -f pre-process/values.yml \
  --set "images.airflow.tag=cosmos-${FIRST_VERSION}" \
  --set workers.replicas=9
kubectl --context kind-kind -n airflow rollout status \
  deployment/airflow-worker --timeout=600s

# Re-render the producer worker against the now-9-replica airflow-worker
# (inheriting the new image tag) so the producer pool's pod spec is in sync.
kubectl --context kind-kind -n airflow get deployment airflow-worker -o json \
  | python3 pre-process/render-producer-worker.py \
  | kubectl --context kind-kind -n airflow apply -f -
kubectl --context kind-kind -n airflow rollout status \
  deployment/airflow-producer-worker --timeout=600s

# --- Sweep loop --------------------------------------------------------------
for v in "${VERSIONS[@]}"; do
  TAG="cosmos-${v}"

  if [ "$v" != "$FIRST_VERSION" ]; then
    # Build + load + redeploy. The build is cached for layers that don't depend
    # on the COSMOS_VERSION arg, so iteration cost is the pip install plus the
    # post-pip RUN dbt deps line.
    pushd "${REPO_ROOT}"
    docker build \
      --build-arg "COSMOS_VERSION=${v}" \
      --build-arg "AIRFLOW_BASE=${AIRFLOW_BASE}" \
      -t "benchmark:${TAG}" \
      -f benchmark/Dockerfile .
    popd
    kind load --name kind docker-image "benchmark:${TAG}"

    helm --kube-context kind-kind upgrade airflow apache-airflow/airflow \
      --version "${CHART_VERSION}" -n airflow -f pre-process/values.yml \
      --set "images.airflow.tag=${TAG}" \
      --set workers.replicas=9
    for d in airflow-api-server airflow-scheduler airflow-worker; do
      kubectl --context kind-kind -n airflow rollout status \
        deployment/$d --timeout=600s
    done

    # Re-render producer worker so it picks up the new image tag from the
    # updated airflow-worker spec.
    kubectl --context kind-kind -n airflow get deployment airflow-worker -o json \
      | python3 pre-process/render-producer-worker.py \
      | kubectl --context kind-kind -n airflow apply -f -
    kubectl --context kind-kind -n airflow rollout status \
      deployment/airflow-producer-worker --timeout=600s
  fi

  # Pick the producer pod once per cosmos version — it's recreated each helm
  # upgrade, so the previous loop's PROD_POD name would be stale here.
  PROD_POD=$(kubectl --context kind-kind -n airflow get pod \
    -l cosmos-role=producer -o jsonpath='{.items[0].metadata.name}')

  for t in "${THREADS[@]}"; do
    # Image bakes in threads:4 (from pre-process/profiles.yml). The regex
    # matches any current value, so we can go 4→8→16 (or any sequence) without
    # tracking the prior threads value across iterations.
    kubectl --context kind-kind exec -n airflow "$PROD_POD" -c worker -- \
      sed -i -E "s/^([[:space:]]*threads:).*/\\1 ${t}/" /opt/airflow/profiles.yml

    METRICS_CSV="$SWEEP_CSV" \
    BENCH_LABEL="cosmos=${v} threads=${t}" \
    DAGS="example_dbt_dag_watcher" \
    REPS="$REPS" \
      ./run-complex-test.sh

    sleep 60
  done
done

# --- Summary -----------------------------------------------------------------
# Build a comma-separated label list matching the BENCH_LABEL values written
# above; summarise-metrics.py uses it to order the table columns.
LABEL_ORDER=""
for v in "${VERSIONS[@]}"; do
  for t in "${THREADS[@]}"; do
    LABEL_ORDER+="cosmos=${v} threads=${t},"
  done
done
LABEL_ORDER="${LABEL_ORDER%,}"

./post-process/summarise-metrics.py "$SWEEP_CSV" --label-order "$LABEL_ORDER" \
  | tee "$SWEEP_MD"

ln -sfn "$SWEEP_CSV" "${RESULTS_DIR}/sweep-latest.csv"
ln -sfn "$SWEEP_MD"  "${RESULTS_DIR}/sweep-latest.md"

touch "$SENTINEL"
echo "SWEEP DONE: $SWEEP_CSV"
