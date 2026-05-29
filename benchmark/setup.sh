#!/bin/bash

set -x
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KEY_FILE="$SCRIPT_DIR/pre-process/key.json"

# Fail fast if the GCP service account key is missing or no longer valid,
# rather than discovering it deep inside a benchmark run.
if [ ! -s "$KEY_FILE" ]; then
  echo "ERROR: $KEY_FILE is missing or empty."
  echo "Download a fresh service account JSON key from GCP project 'astronomer-dag-authoring' and save it to that path."
  exit 1
fi

python3 - "$KEY_FILE" <<'PY' || exit 1
import sys
key_path = sys.argv[1]
try:
    from google.oauth2 import service_account
    from google.auth.transport.requests import Request
except ImportError:
    print(f"WARN: google-auth not installed locally; skipping {key_path} validation.", file=sys.stderr)
    print("      Install with: pip install google-auth", file=sys.stderr)
    sys.exit(0)
try:
    creds = service_account.Credentials.from_service_account_file(
        key_path,
        scopes=["https://www.googleapis.com/auth/cloud-platform"],
    )
    creds.refresh(Request())
except Exception as e:
    print(f"ERROR: {key_path} failed to authenticate with GCP: {e}", file=sys.stderr)
    print("The key has likely been rotated or revoked.", file=sys.stderr)
    print("Download a fresh JSON key from GCP and replace this file.", file=sys.stderr)
    sys.exit(1)
print(f"OK: {key_path} successfully obtained a GCP access token.")
PY

# Pin every kubectl/helm call below to the kind cluster's context so reruns
# can't accidentally target whatever cluster the user's current kube-context
# happens to point at.
KIND_CLUSTER="kind"
KUBE_CONTEXT="kind-${KIND_CLUSTER}"

# Image tag used both for `docker build`/`kind load` and the chart's
# `images.airflow.tag`. Default matches values.yml so unset == legacy behaviour.
# Override (alongside COSMOS_VERSION) when sweeping multiple Cosmos releases
# from a remote runner — see benchmark/remote/run-sweep.sh.
IMAGE_TAG="${IMAGE_TAG:-0.0.7}"

# Airflow chart version (default ships Airflow 3.2.0); override `CHART_VERSION`
# together with `AIRFLOW_BASE` to deploy an older Airflow release — e.g. when
# sweeping a Cosmos version that pre-dates Airflow 3.2 compatibility.
CHART_VERSION="${CHART_VERSION:-1.21.0}"

# Create a Kind cluster (skip if it already exists)
if kind get clusters | grep -q "^${KIND_CLUSTER}$"; then
  echo "Kind cluster '${KIND_CLUSTER}' already exists, skipping creation."
else
  kind create cluster --name "${KIND_CLUSTER}"
fi

# Add the necessary Helm repositories (--force-update is idempotent)
helm repo add --force-update apache-airflow https://airflow.apache.org
helm repo add --force-update prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install or upgrade Prometheus using Helm
helm --kube-context "${KUBE_CONTEXT}" upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  --set prometheus.prometheusSpec.scrapeInterval="5s"

# Wait for the Prometheus pod to be created by the operator (helm install
# returns before the StatefulSet/pod exist), then wait for it to be ready.
until kubectl --context "${KUBE_CONTEXT}" get pod -l app.kubernetes.io/name=prometheus -n monitoring 2>/dev/null | grep -q prometheus; do
  echo "Waiting for Prometheus pod to be created..."
  sleep 2
done
# Bumped to 900s so the wait survives a fresh kind cluster having to pull
# the Prometheus + config-reloader images (~150MB total). Observed the
# config-reloader image alone take ~11 minutes to pull on a cold node.
kubectl --context "${KUBE_CONTEXT}" wait --for=condition=ready pod \
  -l app.kubernetes.io/name=prometheus \
  -n monitoring --timeout=900s

# Expose Prometheus to the host so we can fetch metrics.
#
# Stop only the port-forward that this script started in a previous run
# (tracked by PID file + command-line match), then bail out if 9090 is still
# bound by something unrelated — we don't want to kill arbitrary processes
# the developer happens to have on that port.
if ! command -v lsof >/dev/null 2>&1; then
  echo "ERROR: 'lsof' is required to verify whether port 9090 is in use." >&2
  echo "       Install lsof (e.g., 'brew install lsof' on macOS, 'apt-get install lsof' on Debian/Ubuntu) and re-run." >&2
  exit 1
fi

PID_FILE="/tmp/cosmos-benchmark-prom-port-forward.pid"
PORT_FORWARD_CMD_PATTERN='kubectl.*port-forward.*prometheus-kube-prometheus-prometheus.*9090'

if [ -f "$PID_FILE" ]; then
  prev_pid="$(cat "$PID_FILE" 2>/dev/null || true)"
  if [ -n "$prev_pid" ] \
       && kill -0 "$prev_pid" 2>/dev/null \
       && ps -p "$prev_pid" -o command= 2>/dev/null | grep -Eq "$PORT_FORWARD_CMD_PATTERN"; then
    echo "Stopping previous Prometheus port-forward (pid $prev_pid)."
    kill "$prev_pid" 2>/dev/null || true
    # Give the OS a moment to release the port before the bind check below.
    for _ in 1 2 3 4 5; do
      lsof -ti:9090 >/dev/null 2>&1 || break
      sleep 1
    done
  fi
  rm -f "$PID_FILE"
fi

if lsof -ti:9090 >/dev/null 2>&1; then
  echo "ERROR: port 9090 is in use by another process (not this script's port-forward)."
  echo "       Investigate with: lsof -i:9090   then free the port and re-run."
  exit 1
fi

# Redirect kubectl's per-connection chatter ("Handling connection for 9090") to
# a log file so it doesn't interleave with run-test.sh output. The file is
# overwritten on each setup.sh run and is still inspectable if the port-forward
# misbehaves later.
PORT_FORWARD_LOG="/tmp/cosmos-benchmark-prom-port-forward.log"
kubectl --context "${KUBE_CONTEXT}" port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090 \
  >"$PORT_FORWARD_LOG" 2>&1 &
echo $! > "$PID_FILE"

# Build the docker image that will be used to run the experiments.
# COSMOS_VERSION + AIRFLOW_BASE (both optional) pin those build-args; if unset,
# the Dockerfile's ARG defaults apply.
BUILD_ARGS=()
if [ -n "${COSMOS_VERSION:-}" ]; then
  BUILD_ARGS+=(--build-arg "COSMOS_VERSION=${COSMOS_VERSION}")
fi
if [ -n "${AIRFLOW_BASE:-}" ]; then
  BUILD_ARGS+=(--build-arg "AIRFLOW_BASE=${AIRFLOW_BASE}")
fi
cd ..; docker build "${BUILD_ARGS[@]}" -t "benchmark:${IMAGE_TAG}" -f benchmark/Dockerfile .
kind load --name "${KIND_CLUSTER}" docker-image "benchmark:${IMAGE_TAG}"
cd benchmark

# --- Distributed Airflow setup for Helm-based benchmark experiments. -----------
# Default chart 1.21.0 ships Airflow 3.2.0 (api-server replaces the legacy
# webserver); override CHART_VERSION + AIRFLOW_BASE together when targeting an
# older Airflow release. Chart appVersion must match the image's airflow
# runtime — mismatched pairs surface as migration-job CrashLoopBackOff.

kubectl --context "${KUBE_CONTEXT}" create namespace airflow --dry-run=client -o yaml \
  | kubectl --context "${KUBE_CONTEXT}" apply -f -

# `--set images.airflow.tag` only kicks in when IMAGE_TAG differs from the
# chart-values default; keeps default invocations producing the same release
# manifest as before.
HELM_SET_TAG=()
if [ "$IMAGE_TAG" != "0.0.7" ]; then
  HELM_SET_TAG=(--set "images.airflow.tag=${IMAGE_TAG}")
fi
helm --kube-context "${KUBE_CONTEXT}" upgrade --install airflow apache-airflow/airflow \
  --version "${CHART_VERSION}" \
  --namespace airflow \
  -f pre-process/values.yml \
  "${HELM_SET_TAG[@]}"

kubectl --context "${KUBE_CONTEXT}" -n airflow rollout status deployment/airflow-worker --timeout=600s

# Deploy the dedicated producer worker pool. The manifest is derived from the
# chart's rendered worker Deployment so ServiceAccount / ConfigMap / Secret
# references stay in sync with whatever the chart wired up — we only override
# queue, labels, replicas, resources, and Celery concurrency. Tunable per run
# via env vars:
#   PRODUCER_REPLICAS PRODUCER_CPU PRODUCER_MEM PRODUCER_QUEUE PRODUCER_CONCURRENCY
#
# The env-var assignments must hug the python3 invocation — putting them
# before `kubectl` would scope them to kubectl's environment only and leave
# the renderer with its built-in defaults.
kubectl --context "${KUBE_CONTEXT}" -n airflow get deployment airflow-worker -o json \
  | PRODUCER_REPLICAS="${PRODUCER_REPLICAS:-1}" \
    PRODUCER_CPU="${PRODUCER_CPU:-1}" \
    PRODUCER_MEM="${PRODUCER_MEM:-2Gi}" \
    PRODUCER_QUEUE="${PRODUCER_QUEUE:-producer}" \
    PRODUCER_CONCURRENCY="${PRODUCER_CONCURRENCY:-1}" \
    python3 pre-process/render-producer-worker.py \
  | kubectl --context "${KUBE_CONTEXT}" -n airflow apply -f -

kubectl --context "${KUBE_CONTEXT}" -n airflow rollout status deployment/airflow-producer-worker --timeout=600s

# Expose the api-server so we can trigger DAG runs from outside the cluster.
kubectl --context "${KUBE_CONTEXT}" port-forward svc/airflow-api-server 8080:8080 -n airflow &
