#!/bin/bash

#set -v
#set -x
#set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <job-name>"
  exit 1
fi

JOB_NAME="$1"

# Get the pod name associated with the job
export JOB_POD_NAME=$(kubectl get pods --selector=job-name="$JOB_NAME" -o jsonpath="{.items[0].metadata.name}")

PROM_API="http://localhost:9090/api/v1/query"
TIME_RANGE="240h"

query_prometheus() {
  local query="$1"
  curl -s --data-urlencode "query=${query}" "$PROM_API" | jq -r '.data.result[0].value[1]'
}

# Converts seconds to hh:mm:ss
seconds_to_hhmmss() {
  local total_seconds=${1%.*}
  printf "%02d:%02d:%02d\n" $((total_seconds / 3600)) $(((total_seconds % 3600) / 60)) $((total_seconds % 60))
}

echo "Fetching metrics for pod: $JOB_POD_NAME"

# CPU max utilization over $TIME_RANGE
CPU_MAX_QUERY="max_over_time(rate(container_cpu_usage_seconds_total{pod=\"$JOB_POD_NAME\", container=\"dbt\"}[1m])[${TIME_RANGE}:])"
CPU_MAX=$(query_prometheus "$CPU_MAX_QUERY")

# CPU stddev over last 5 minutes
CPU_STDDEV_QUERY="stddev_over_time(rate(container_cpu_usage_seconds_total{pod=\"$JOB_POD_NAME\", container=\"dbt\"}[1m])[${TIME_RANGE}:])"
CPU_STDDEV=$(query_prometheus "$CPU_STDDEV_QUERY")

# Cumulative CPU seconds consumed over the pod's lifetime (total compute work)
CPU_TOTAL_QUERY="increase(container_cpu_usage_seconds_total{pod=\"$JOB_POD_NAME\", container=\"dbt\"}[${TIME_RANGE}])"
CPU_TOTAL=$(query_prometheus "$CPU_TOTAL_QUERY")

# Memory max usage over last 5 minutes
MEM_MAX_QUERY="max_over_time(container_memory_usage_bytes{pod=\"$JOB_POD_NAME\", container=\"dbt\"}[${TIME_RANGE}])"
MEM_MAX=$(query_prometheus "$MEM_MAX_QUERY")

# Memory stddev over last 5 minutes
MEM_STDDEV_QUERY="stddev_over_time(container_memory_usage_bytes{pod=\"$JOB_POD_NAME\", container=\"dbt\"}[${TIME_RANGE}])"
MEM_STDDEV=$(query_prometheus "$MEM_STDDEV_QUERY")

echo ""
echo "Metrics for Pod: $JOB_POD_NAME (last $TIME_RANGE)"
echo "----------------------------------------------"
echo "Max CPU Utilization (cores):    $CPU_MAX"
echo "Stddev CPU Utilization (cores): $CPU_STDDEV"
echo "Total CPU Seconds Consumed:     $CPU_TOTAL"

bytes_to_human() {
  local b=${1%.*}
  b=${b:-0}

  if (( b < 1024 )); then
    echo "${b} B"
  elif (( b < 1048576 )); then
    echo "$((b / 1024)) KiB"
  elif (( b < 1073741824 )); then
    echo "$((b / 1048576)) MiB"
  else
    echo "$((b / 1073741824)) GiB"
  fi
}

MEM_MAX_HUMAN=$(bytes_to_human "$MEM_MAX")
MEM_STDDEV_HUMAN=$(bytes_to_human "$MEM_STDDEV")

echo "Max Memory Usage:     $MEM_MAX_HUMAN"
echo "Stddev Memory Usage:  $MEM_STDDEV_HUMAN"

# Get pod start time and end time as Unix timestamps
START_TS_QUERY="kube_pod_start_time{pod=\"$JOB_POD_NAME\"}"
END_TS_QUERY="kube_pod_completion_time{pod=\"$JOB_POD_NAME\"}"

START_TS=$(query_prometheus "$START_TS_QUERY")
END_TS=$(query_prometheus "$END_TS_QUERY")

# Validate both timestamps
if [[ -z "$START_TS" || "$START_TS" == "null" || -z "$END_TS" || "$END_TS" == "null" ]]; then
  echo "Could not determine job duration."
  HHMMSS="00:00:00"
else
  DURATION_SECONDS=$(echo "$END_TS - $START_TS" | bc)
  HHMMSS=$(seconds_to_hhmmss "$DURATION_SECONDS")
fi

echo "Job Duration: $HHMMSS"
