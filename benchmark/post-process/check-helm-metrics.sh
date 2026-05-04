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

if [ -z "$1" ]; then
  echo "Usage: $0 <dag-name>"
  exit 1
fi

DAG_NAME="$1"
PROM_API="http://localhost:9090/api/v1/query"
NAMESPACE="${NAMESPACE:-airflow}"

# Discover the latest DAG run window from Airflow metadata.
API_POD=$(kubectl get pods -n "$NAMESPACE" -l component=api-server -o jsonpath="{.items[0].metadata.name}")
RUN_JSON=$(kubectl exec -n "$NAMESPACE" "$API_POD" -- \
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

# Instant Prometheus query evaluated at the run's end timestamp, with a
# range vector covering exactly the run window.
query_prometheus() {
  curl -s --data-urlencode "query=$1" --data-urlencode "time=${END_EPOCH}" "$PROM_API" \
    | jq -r '.data.result[0].value[1] // "n/a"'
}

bytes_to_human() {
  local b=${1%.*}
  b=${b:-0}
  if (( b < 1024 )); then echo "${b} B"
  elif (( b < 1048576 )); then echo "$((b / 1024)) KiB"
  elif (( b < 1073741824 )); then echo "$((b / 1048576)) MiB"
  else echo "$((b / 1073741824)) GiB"
  fi
}

report_pool() {
  local pool_label="$1"
  local pod_regex="$2"
  local pod_filter="namespace=\"${NAMESPACE}\", pod=~\"${pod_regex}\", container=\"worker\""

  local cpu_max
  cpu_max=$(query_prometheus "max_over_time(sum(rate(container_cpu_usage_seconds_total{${pod_filter}}[1m]))[${DURATION}s:])")
  local cpu_total
  cpu_total=$(query_prometheus "sum(increase(container_cpu_usage_seconds_total{${pod_filter}}[${DURATION}s]))")
  local mem_max
  mem_max=$(query_prometheus "max_over_time(sum(container_memory_working_set_bytes{${pod_filter}})[${DURATION}s:])")

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
echo "================================================================="

# Prometheus matchers are anchored, so "airflow-worker-.+" does NOT also catch
# "airflow-producer-worker-..." pods.
report_pool "producer" "airflow-producer-worker-.+"
report_pool "consumer" "airflow-worker-.+"
