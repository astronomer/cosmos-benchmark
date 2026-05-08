#!/bin/bash

#set -v
#set -x
set -e

export PYTHONWARNINGS="ignore"

DAG_NAME="${DAG_NAME:-example_operator_build}"
# Bound the polling loop so a wedged DAG run can't hang forever (defaults
# to 60 minutes; override with MAX_WAIT_SECONDS).
MAX_WAIT_SECONDS="${MAX_WAIT_SECONDS:-3600}"
POLL_INTERVAL_SECONDS="${POLL_INTERVAL_SECONDS:-5}"

# Airflow 3 CLI exposes the field as `run_id`; older CLIs used `dag_run_id`.
RUN_ID=$(airflow dags trigger $DAG_NAME --output json | tail -1 | jq '.[0].run_id // .[0].dag_run_id')

start_time=$(date --iso-8601=seconds)
elapsed=0

while [ "$elapsed" -lt "$MAX_WAIT_SECONDS" ]; do
    STATUS=$(airflow dags list-runs $DAG_NAME --output json | jq ".[] | select(.run_id == $RUN_ID) | .state")
    echo $STATUS

    if [[ $STATUS =~ "success" ]]; then
        echo "DAG run $RUN_ID succeeded"
        break
    elif [[ $STATUS =~ "failed" || $STATUS =~ "skipped" ]]; then
        echo "DAG run $RUN_ID ended with state: $STATUS"
        exit 1
    else
        echo "DAG run $RUN_ID is in state: $STATUS. Waiting..."
        sleep "$POLL_INTERVAL_SECONDS"
        elapsed=$((elapsed + POLL_INTERVAL_SECONDS))
    fi
done

if [[ ! $STATUS =~ "success" ]]; then
    echo "DAG run $RUN_ID did not reach a terminal state within ${MAX_WAIT_SECONDS}s (last state: $STATUS)"
    exit 1
fi

end_time=$(date --iso-8601=seconds)

start_sec=$(date -d "$start_time" +%s)
end_sec=$(date -d "$end_time" +%s)
duration=$((end_sec - start_sec))

echo "Start: $start_time"
echo "End:   $end_time"
echo "Duration: ${duration} seconds"
