#!/bin/bash

# Extracts the Cosmos parse-time log line(s) from the job pod's stdout.
# Cosmos emits lines like:
#   Cosmos performance (example_dbt_dag) -  [host|pid]: It took 0.068s to parse
#   the dbt project for DAG using LoadMode.DBT_LS_CACHE
# and a matching "to build the Airflow DAG." line right after. Cache hit/miss
# lines from cosmos/dbt/graph.py are included too so you can see which path
# the parse actually took.

if [ -z "$1" ]; then
  echo "Usage: $0 <job-name>"
  exit 1
fi

JOB_NAME="$1"

POD_NAME=$(kubectl get pods --selector=job-name="$JOB_NAME" -o jsonpath="{.items[0].metadata.name}")

if [ -z "$POD_NAME" ]; then
  echo "No pod found for job $JOB_NAME"
  exit 1
fi

echo ""
echo "Cosmos parse-time log for Pod: $POD_NAME"
echo "----------------------------------------------"

MATCHES=$(kubectl logs "$POD_NAME" 2>/dev/null \
  | grep -E "to parse the dbt project|to build the Airflow DAG|Cosmos performance: Cache (hit|miss)")

if [ -z "$MATCHES" ]; then
  echo "(no Cosmos parse-time line found — DAG may not have parsed, or log level is below INFO)"
else
  echo "$MATCHES"
fi
