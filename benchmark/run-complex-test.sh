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

# Count reps whose DAG run did not reach success, so a long sweep doesn't
# silently look complete when some cells lost reps to a flaky model.
FAILED_REPS=0

for RUN_DAG_NAME in $DAGS; do
  for ((i=1; i<=REPS; i++)); do
    echo -e "\n\n\n=== Run #$i for $RUN_DAG_NAME ==="
    echo Start time: $(date +"%Y-%m-%dT%H:%M:%S%z")

    # Wait for api-server (Airflow 3 replaces webserver), scheduler deployments
    for deploy in airflow-api-server airflow-scheduler ; do
      kubectl --context "$KUBE_CONTEXT" wait --for=condition=Available deployment/$deploy -n airflow --timeout=300s
    done

    # Wait for both worker pools (CeleryExecutor)
    kubectl --context "$KUBE_CONTEXT" -n airflow rollout status deployment/airflow-worker --timeout=300s
    kubectl --context "$KUBE_CONTEXT" -n airflow rollout status deployment/airflow-producer-worker --timeout=300s

    API_POD=$(kubectl --context "$KUBE_CONTEXT" get pods -n airflow -l component=api-server -o jsonpath="{.items[0].metadata.name}")

    # A single flaky DAG run (e.g. the intermittent fhir-dbt-analytics model)
    # must NOT abort the whole sweep — that wastes hours of prior reps. The
    # `if` guard keeps `set -e` from killing the loop when trigger_dag.sh
    # exits non-zero; we log the failed rep, skip its metrics (a failed run's
    # numbers aren't comparable), and continue to the next rep.
    if kubectl --context "$KUBE_CONTEXT" exec -n airflow "$API_POD" -- env DAG_NAME="$RUN_DAG_NAME" bash /opt/airflow/trigger_dag.sh; then
      echo End time: $(date +"%Y-%m-%dT%H:%M:%S%z")
      sleep 40
      KUBE_CONTEXT="$KUBE_CONTEXT" ./post-process/report-dag-run-pool-metrics.sh "$RUN_DAG_NAME" \
        || echo "WARNING: metrics report failed for run #$i of $RUN_DAG_NAME; continuing."
    else
      FAILED_REPS=$((FAILED_REPS + 1))
      echo "WARNING: DAG run #$i for $RUN_DAG_NAME did not reach success; skipping its metrics and continuing the sweep."
    fi
  done
done

if [ "$FAILED_REPS" -gt 0 ]; then
  echo "NOTE: ${FAILED_REPS} rep(s) failed during this sweep and were skipped. Affected cells will have fewer rows than REPS."
fi
