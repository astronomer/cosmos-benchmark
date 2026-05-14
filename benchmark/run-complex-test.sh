#!/bin/bash

set -v
set -x
set -e

# Configurable via env:
#   DAGS          space-separated DAG ids to run (default: example_dbt_dag_watcher example_dbt_dag example_operator_build)
#   REPS          repetitions per DAG (default: 1)
#   KUBE_CONTEXT  kubectl context to target (default: kind-kind, matching setup.sh)
DAGS="${DAGS:-example_dbt_dag_watcher example_dbt_dag example_operator_build}"
REPS="${REPS:-1}"
KUBE_CONTEXT="${KUBE_CONTEXT:-kind-kind}"

for RUN_DAG_NAME in $DAGS; do
  for ((i=1; i<=REPS; i++)); do
    echo -e "\n\n\n=== Run #$i for $RUN_DAG_NAME ==="
    echo Start time: $(date +"%Y-%m-%dT%H:%M:%S%z")

    # Wait for api-server (Airflow 3 replaces webserver), scheduler deployments
    for deploy in airflow-api-server airflow-scheduler ; do
      kubectl --context "$KUBE_CONTEXT" wait --for=condition=Available deployment/$deploy -n airflow --timeout=300s
    done

    # Wait for the worker pool (CeleryExecutor)
    kubectl --context "$KUBE_CONTEXT" -n airflow rollout status deployment/airflow-worker --timeout=300s

    API_POD=$(kubectl --context "$KUBE_CONTEXT" get pods -n airflow -l component=api-server -o jsonpath="{.items[0].metadata.name}")
    kubectl --context "$KUBE_CONTEXT" exec -n airflow "$API_POD" -- env DAG_NAME="$RUN_DAG_NAME" bash /opt/airflow/trigger_dag.sh

    echo End time: $(date +"%Y-%m-%dT%H:%M:%S%z")
    sleep 40
  done
done
