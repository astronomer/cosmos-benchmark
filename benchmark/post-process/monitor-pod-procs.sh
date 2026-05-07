#!/bin/bash
#
# Sample per-process CPU + RSS inside the producer + consumer worker pods,
# every N seconds, until the named DAG run reaches a terminal state.
#
# Usage:
#   monitor-pod-procs.sh <DAG_NAME> [interval_seconds] [output_csv]
#
# Env:
#   RUN_ID=<run_id>   Track a specific DAG run id and exit when it terminates.
#                     If unset, the script tracks the latest run of $DAG_NAME
#                     and exits when that run terminates (which can race with
#                     a freshly triggered run — prefer setting RUN_ID).
#
# The output CSV columns are:
#   ts,pod,role,classification,pid,rss_kb,cpu_jiffies,cmdline
#
# `role` comes from the pod label `cosmos-role` (producer / consumer / unset).
# Use `aggregate-pod-procs.py` to summarise the CSV by classification.

set -e
set -u

DAG="${1:?usage: $0 <DAG_NAME> [interval_seconds] [output_csv]}"
INTERVAL="${2:-2}"
CSV="${3:-/tmp/cosmos-bench-procs-${DAG}.csv}"

CONTEXT="${KUBE_CONTEXT:-kind-kind}"
NAMESPACE="${NAMESPACE:-airflow}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SAMPLER_SCRIPT="${SCRIPT_DIR}/inside-pod-procs.py"

if [ ! -s "$SAMPLER_SCRIPT" ]; then
  echo "ERROR: sampler script missing: $SAMPLER_SCRIPT" >&2
  exit 1
fi

echo "ts,pod,role,classification,pid,rss_kb,cpu_jiffies,cmdline" > "$CSV"
echo "[monitor-pod-procs] writing samples to $CSV (interval=${INTERVAL}s, DAG=$DAG)"

trap 'echo "[monitor-pod-procs] caught signal, stopping"; exit 0' SIGTERM SIGINT

while true; do
  # Refresh pod list each iteration so we pick up restarts / new replicas.
  # We sample worker pools (producer + consumer) plus the Airflow infra pods
  # because in WATCHER mode deferred sensors run on the triggerer, and
  # scheduler/dag-processor/api-server are non-trivial CPU draws too.
  # Roles surface in the CSV: producer | consumer | triggerer | scheduler |
  # dag_processor | api_server. Container name is auto-detected per pod.
  PODS_TSV=$(kubectl --context "$CONTEXT" -n "$NAMESPACE" get pods -o json 2>/dev/null \
    | python3 -c '
import json, sys
data = json.load(sys.stdin)
component_to_role = {
    "worker": "consumer",
    "producer-worker": "producer",
    "triggerer": "triggerer",
    "scheduler": "scheduler",
    "dag-processor": "dag_processor",
    "api-server": "api_server",
}
component_to_container = {
    "worker": "worker",
    "producer-worker": "worker",
    "triggerer": "triggerer",
    "scheduler": "scheduler",
    "dag-processor": "dag-processor",
    "api-server": "api-server",
}
for item in data.get("items", []):
    labels = item["metadata"].get("labels", {})
    component = labels.get("component", "")
    cosmos_role = labels.get("cosmos-role", "")
    if cosmos_role == "producer":
        role = "producer"
    elif component in component_to_role:
        role = component_to_role[component]
    else:
        continue
    name = item["metadata"]["name"]
    container = component_to_container.get(component, component)
    print(f"{name}\t{role}\t{container}")
' 2>/dev/null || true)

  if [ -z "$PODS_TSV" ]; then
    echo "[monitor-pod-procs] no airflow pods found yet, retrying"
    sleep "$INTERVAL"
    continue
  fi

  while IFS=$'\t' read -r pod role container; do
    [ -z "$pod" ] && continue
    role="${role:-unknown}"
    container="${container:-worker}"
    out=$(kubectl --context "$CONTEXT" -n "$NAMESPACE" exec -i "$pod" -c "$container" -- python3 - < "$SAMPLER_SCRIPT" 2>/dev/null) || continue
    while IFS= read -r line; do
      [ -z "$line" ] && continue
      # Python sampler outputs: "ts,classification,pid,rss,jiffies,cmdline".
      # We insert pod+role between ts and classification.
      printf '%s,%s,%s\n' "${line%%,*}" "${pod},${role}" "${line#*,}" >> "$CSV"
    done <<< "$out"
  done <<< "$PODS_TSV"

  STATE=$(kubectl --context "$CONTEXT" -n "$NAMESPACE" exec deployment/airflow-api-server -- \
    airflow dags list-runs "$DAG" --output json 2>/dev/null \
    | RUN_ID="${RUN_ID:-}" python3 -c "import json,os,sys
target=os.environ.get('RUN_ID') or ''
try:
    d=json.load(sys.stdin) or []
    if target:
        m=[r for r in d if r.get('run_id')==target]
        print((m[0].get('state','') if m else ''))
    else:
        print(d[0].get('state','') if d else '')
except Exception:
    pass" 2>/dev/null || true)

  if [[ "$STATE" == "success" || "$STATE" == "failed" ]]; then
    echo "[monitor-pod-procs] DAG $DAG terminal state: $STATE — wrote $(wc -l < "$CSV") rows to $CSV"
    break
  fi
  sleep "$INTERVAL"
done
