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

    # Gate on a COMPLETE rollout (not just condition=Available) for every
    # deployment we touch. During a rolling update a deployment reports
    # Available as soon as minAvailable is met — while an old pod is still
    # terminating. Grabbing that pod's name and exec-ing into it then races
    # into a SIGKILL (exit 137) when the container shuts down mid-exec.
    # `rollout status` blocks until the old ReplicaSet is fully scaled down, so
    # the pod we select below is the live one. (api-server + scheduler are
    # Airflow 3's control plane; the two worker pools run under CeleryExecutor.)
    for deploy in airflow-api-server airflow-scheduler airflow-worker airflow-producer-worker ; do
      kubectl --context "$KUBE_CONTEXT" -n airflow rollout status deployment/$deploy --timeout=300s
    done

    # Trigger the DAG from inside an api-server pod, re-resolving the pod name
    # on each attempt (it changes across rollouts) and restricting to Running
    # pods so we don't pick one that's still terminating.
    #
    # Retry ONLY when the exec itself is killed at the infra level (exit >128,
    # e.g. 137/SIGKILL on a terminating pod) — that's a harness race, not a
    # benchmark result. A clean non-zero exit from trigger_dag.sh (e.g. 1) means
    # the DAG genuinely reached a failed/timeout state; we do NOT retry that, so
    # a real flaky rep is still counted in FAILED_REPS rather than masked.
    #
    # The flaky-rep accounting itself: a single bad DAG run must NOT abort the
    # whole sweep (that wastes hours of prior reps), so we capture the exit code
    # instead of letting `set -e` kill the loop, log it, skip its metrics (a
    # failed run's numbers aren't comparable), and continue to the next rep.
    trigger_rc=1
    for attempt in 1 2 3 ; do
      API_POD=$(kubectl --context "$KUBE_CONTEXT" -n airflow get pods \
        -l component=api-server --field-selector=status.phase=Running \
        -o jsonpath="{.items[0].metadata.name}")
      if [ -z "$API_POD" ]; then
        echo "WARNING: no Running api-server pod yet (attempt $attempt); retrying..."
        sleep 10
        continue
      fi
      set +e
      kubectl --context "$KUBE_CONTEXT" exec -n airflow "$API_POD" -- \
        env DAG_NAME="$RUN_DAG_NAME" bash /opt/airflow/trigger_dag.sh
      trigger_rc=$?
      set -e
      # <=128: clean success (0) or a genuine DAG failure — don't retry either.
      [ "$trigger_rc" -le 128 ] && break
      echo "WARNING: trigger exec on $API_POD killed (exit $trigger_rc, attempt $attempt); pod was likely terminating — retrying on a fresh pod..."
      sleep 10
    done

    if [ "$trigger_rc" -eq 0 ]; then
      echo End time: $(date +"%Y-%m-%dT%H:%M:%S%z")
      sleep 40
      KUBE_CONTEXT="$KUBE_CONTEXT" ./post-process/report-dag-run-pool-metrics.sh "$RUN_DAG_NAME" \
        || echo "WARNING: metrics report failed for run #$i of $RUN_DAG_NAME; continuing."
    else
      FAILED_REPS=$((FAILED_REPS + 1))
      echo "WARNING: DAG run #$i for $RUN_DAG_NAME did not reach success (exit $trigger_rc); skipping its metrics and continuing the sweep."
    fi
  done
done

if [ "$FAILED_REPS" -gt 0 ]; then
  echo "NOTE: ${FAILED_REPS} rep(s) failed during this sweep and were skipped. Affected cells will have fewer rows than REPS."
fi
