#!/bin/bash

set -v
set -x
set -e

# Configurable via env:
#   DAGS  space-separated DAG ids to run (default: all three benchmark DAGs)
#   REPS  repetitions per DAG (default: 1)
DAGS="${DAGS:-example_dbt_dag_watcher example_dbt_dag example_operator_build}"
REPS="${REPS:-1}"

for RUN_DAG_NAME in $DAGS; do
  for ((i=1; i<=REPS; i++)); do
    echo -e "\n\n\n=== Run #$i for $RUN_DAG_NAME ==="
    echo Start time: $(date +"%Y-%m-%dT%H:%M:%S%z")

    # Wait for api-server (Airflow 3 replaces webserver), scheduler deployments
    for deploy in airflow-api-server airflow-scheduler ; do
      kubectl wait --for=condition=Available deployment/$deploy -n airflow --timeout=300s
    done

    # Wait for both worker pools (CeleryExecutor)
    kubectl -n airflow rollout status deployment/airflow-worker --timeout=300s
    kubectl -n airflow rollout status deployment/airflow-producer-worker --timeout=300s

    API_POD=$(kubectl get pods -n airflow -l component=api-server -o jsonpath="{.items[0].metadata.name}")
    kubectl exec -n airflow "$API_POD" -- env DAG_NAME="$RUN_DAG_NAME" bash /opt/airflow/trigger_dag.sh

    echo End time: $(date +"%Y-%m-%dT%H:%M:%S%z")
    sleep 40
    ./post-process/check-helm-metrics.sh "$RUN_DAG_NAME"
  done
done
