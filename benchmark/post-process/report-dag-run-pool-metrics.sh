#!/bin/bash

# Aggregate Prometheus metrics for the Helm-based Airflow setup, grouped by
# worker pool (producer vs consumer). Used by run-complex-test.sh after a
# DAG run completes.
#
# We scope every Prometheus query to the latest DAG run's [start_date, end_date]
# window so historical pod incarnations from earlier iterations don't pollute
# the totals. Pool selection is by pod-name regex against pods in the `airflow`
# namespace:
#   producer pool: airflow-producer-worker-.+
#   consumer pool: airflow-worker-.+    (chart's default workers)
#
# Optional env vars:
#   METRICS_CSV   if set, append a one-line CSV row to this file. Writes a
#                 header row first when the file is created — subsequent runs
#                 append data only.
#   BENCH_LABEL   free-form label included in the CSV row (e.g. "LOCAL",
#                 "WATCHER threads=8"). Empty if not set.
#   NAMESPACE     k8s namespace (default: airflow)
#   KUBE_CONTEXT  kubectl context (default: kind-kind)

if [ -z "$1" ]; then
  echo "Usage: $0 <dag-name>"
  exit 1
fi

DAG_NAME="$1"
PROM_API="http://localhost:9090/api/v1/query"
NAMESPACE="${NAMESPACE:-airflow}"
KUBE_CONTEXT="${KUBE_CONTEXT:-kind-kind}"

# Discover the latest DAG run window from Airflow metadata.
API_POD=$(kubectl --context "$KUBE_CONTEXT" get pods -n "$NAMESPACE" -l component=api-server -o jsonpath="{.items[0].metadata.name}")
RUN_JSON=$(kubectl --context "$KUBE_CONTEXT" exec -n "$NAMESPACE" "$API_POD" -- \
  airflow dags list-runs "$DAG_NAME" --output json 2>/dev/null \
  | python3 -c "import json,sys;data=json.load(sys.stdin);print(json.dumps(data[0]) if data else '{}')")

START_DATE=$(echo "$RUN_JSON" | jq -r '.start_date // empty')
END_DATE=$(echo "$RUN_JSON" | jq -r '.end_date // empty')
RUN_ID=$(echo "$RUN_JSON" | jq -r '.run_id // .dag_run_id // empty')
RUN_STATE=$(echo "$RUN_JSON" | jq -r '.state // empty')

if [ -z "$START_DATE" ] || [ -z "$END_DATE" ]; then
  echo "Could not determine DAG run start/end. Has the run finished?"
  exit 1
fi

# Convert ISO timestamps to Unix epoch via Python — robust across BSD/GNU
# `date` and across timezone-aware ISO 8601 forms with fractional seconds.
to_epoch() {
  python3 -c "import datetime,sys; print(int(datetime.datetime.fromisoformat(sys.argv[1].replace('Z','+00:00')).timestamp()))" "$1"
}
START_EPOCH=$(to_epoch "$START_DATE")
END_EPOCH=$(to_epoch "$END_DATE")
DURATION=$(( END_EPOCH - START_EPOCH ))
[ "$DURATION" -lt 1 ] && DURATION=1

# Per-task state list — used for both producer task duration (WATCHER only)
# and total/success task counts (a sanity-check that the run wasn't partial).
TASK_STATES_JSON=$(kubectl --context "$KUBE_CONTEXT" exec -n "$NAMESPACE" "$API_POD" -- \
  airflow tasks states-for-dag-run "$DAG_NAME" "$RUN_ID" --output json 2>/dev/null)

PRODUCER_TASK_JSON=$(echo "$TASK_STATES_JSON" | python3 -c "import json,sys;data=json.loads(sys.stdin.read() or '[]');print(json.dumps(next((t for t in data if t.get('task_id') == 'dbt_producer_watcher'), {})))")
PRODUCER_START=$(echo "$PRODUCER_TASK_JSON" | jq -r '.start_date // empty')
PRODUCER_END=$(echo "$PRODUCER_TASK_JSON" | jq -r '.end_date // empty')
if [ -n "$PRODUCER_START" ] && [ -n "$PRODUCER_END" ]; then
  PRODUCER_DURATION=$(( $(to_epoch "$PRODUCER_END") - $(to_epoch "$PRODUCER_START") ))
  TAIL_DURATION=$(( DURATION - PRODUCER_DURATION ))
  [ "$TAIL_DURATION" -lt 0 ] && TAIL_DURATION=0
else
  PRODUCER_DURATION=""
  TAIL_DURATION=""
fi

TASKS_TOTAL=$(echo "$TASK_STATES_JSON" | python3 -c "import json,sys;print(len(json.loads(sys.stdin.read() or '[]')))")
TASKS_SUCCESS=$(echo "$TASK_STATES_JSON" | python3 -c "import json,sys;print(sum(1 for t in json.loads(sys.stdin.read() or '[]') if t.get('state')=='success'))")

# Instant Prometheus query evaluated at the run's end timestamp, with a
# range vector covering exactly the run window.
query_prometheus() {
  curl -s --data-urlencode "query=$1" --data-urlencode "time=${END_EPOCH}" "$PROM_API" \
    | jq -r '.data.result[0].value[1] // "n/a"'
}

bytes_to_human() {
  # Always emit MiB once we are over the KiB range so callers can compare
  # values across runs without losing precision to GiB truncation. Anything
  # in the GiB range gets shown as e.g. "9785 MiB (9.55 GiB)".
  # Pass non-numeric inputs (e.g. the "n/a" sentinel from query_prometheus
  # when a query returned no data) through unchanged so the report stays
  # readable instead of erroring inside the arithmetic below.
  case "${1:-}" in
    ''|n/a)         echo "n/a"; return ;;
    *[!0-9.]*)      echo "${1}"; return ;;
  esac
  local b=${1%.*}
  b=${b:-0}
  if (( b < 1024 )); then
    echo "${b} B"
  elif (( b < 1048576 )); then
    echo "$((b / 1024)) KiB"
  else
    local mib=$((b / 1048576))
    local gib_q=$((mib / 1024))
    local gib_r=$(( (mib * 100 / 1024) % 100 ))
    if (( mib >= 1024 )); then
      printf "%d MiB (%d.%02d GiB)\n" "$mib" "$gib_q" "$gib_r"
    else
      printf "%d MiB\n" "$mib"
    fi
  fi
}

# Compute the three per-pool metrics and stash them in globals named
# ${var_prefix}_CPU_MAX, ${var_prefix}_CPU_TOTAL, ${var_prefix}_MEM_BYTES.
# bash 3.2 (macOS default) has no associative arrays, so we use eval here.
report_pool() {
  local pool_label="$1"
  local pod_regex="$2"
  local var_prefix="$3"
  local pod_filter="namespace=\"${NAMESPACE}\", pod=~\"${pod_regex}\", container=\"worker\""

  local cpu_max cpu_total mem_max
  cpu_max=$(query_prometheus "max_over_time(sum(rate(container_cpu_usage_seconds_total{${pod_filter}}[1m]))[${DURATION}s:])")
  cpu_total=$(query_prometheus "sum(increase(container_cpu_usage_seconds_total{${pod_filter}}[${DURATION}s]))")
  mem_max=$(query_prometheus "max_over_time(sum(container_memory_working_set_bytes{${pod_filter}})[${DURATION}s:])")

  eval "${var_prefix}_CPU_MAX=\"\$cpu_max\""
  eval "${var_prefix}_CPU_TOTAL=\"\$cpu_total\""
  eval "${var_prefix}_MEM_BYTES=\"\$mem_max\""

  echo ""
  echo "--- ${pool_label} pool (pods matching: ${pod_regex}) ---"
  echo "Max CPU Utilization (cores, summed across pool):    ${cpu_max}"
  echo "Total CPU Seconds Consumed (summed across pool):    ${cpu_total}"
  echo "Max Memory Working Set (summed across pool):        $(bytes_to_human "$mem_max")"
}

echo "Metrics for DAG run: ${DAG_NAME}"
echo "  run_id:   ${RUN_ID}"
echo "  state:    ${RUN_STATE}"
echo "  start:    ${START_DATE}"
echo "  end:      ${END_DATE}"
echo "  duration: ${DURATION}s"
[ -n "${PRODUCER_DURATION}" ] && echo "  producer task duration: ${PRODUCER_DURATION}s"
[ -n "${TAIL_DURATION}" ] && echo "  tail (DAG − producer):  ${TAIL_DURATION}s"
echo "  tasks:    ${TASKS_SUCCESS}/${TASKS_TOTAL} succeeded"
[ -n "${BENCH_LABEL:-}" ] && echo "  label:    ${BENCH_LABEL}"
echo "================================================================="

# Prometheus matchers are anchored, so "airflow-worker-.+" does NOT also catch
# "airflow-producer-worker-..." pods.
report_pool "producer" "airflow-producer-worker-.+" "PRODUCER"
report_pool "consumer" "airflow-worker-.+" "CONSUMER"

# Combined view — useful for an apples-to-apples LOCAL-vs-WATCHER comparison,
# because LOCAL has no producer task at all so its producer pool sits idle.
report_pool "total (producer + consumer)" "airflow(-producer)?-worker-.+" "TOTAL"

if [ -n "${METRICS_CSV:-}" ]; then
  python3 - "$METRICS_CSV" \
    "$END_DATE" "${BENCH_LABEL:-}" "$DAG_NAME" "$RUN_ID" "$RUN_STATE" "$DURATION" \
    "$PRODUCER_DURATION" "$TAIL_DURATION" "$TASKS_TOTAL" "$TASKS_SUCCESS" \
    "$PRODUCER_CPU_MAX" "$PRODUCER_CPU_TOTAL" "$PRODUCER_MEM_BYTES" \
    "$CONSUMER_CPU_MAX" "$CONSUMER_CPU_TOTAL" "$CONSUMER_MEM_BYTES" \
    "$TOTAL_CPU_MAX" "$TOTAL_CPU_TOTAL" "$TOTAL_MEM_BYTES" <<'PY'
# RFC 4180 CSV emission via the stdlib csv module — handles quoting / escaping
# correctly even if a future BENCH_LABEL or other field contains a comma,
# double-quote, or newline. Header is written only when the file is new.
import csv, os, sys
path, *row = sys.argv[1:]
header = [
    "run_at", "label", "dag_id", "run_id", "state", "duration_s",
    "producer_duration_s", "tail_s", "tasks_total", "tasks_success",
    "producer_max_cpu_cores", "producer_total_cpu_s", "producer_peak_mem_bytes",
    "consumer_max_cpu_cores", "consumer_total_cpu_s", "consumer_peak_mem_bytes",
    "total_max_cpu_cores", "total_total_cpu_s", "total_peak_mem_bytes",
]
need_header = not os.path.exists(path) or os.path.getsize(path) == 0
with open(path, "a", newline="") as f:
    w = csv.writer(f)
    if need_header:
        w.writerow(header)
    w.writerow(row)
PY
  echo ""
  echo "Appended CSV row to ${METRICS_CSV}"
fi
