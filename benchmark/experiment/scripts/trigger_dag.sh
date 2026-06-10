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

# The Airflow 3 CLI interleaves INFO log lines (alembic plugin setup, etc.) with
# the `--output json` payload on stdout, and the JSON array is emitted as a
# single line. Two robustness measures everywhere we read JSON:
#   1. Capture the full output into a variable BEFORE parsing. Piping straight
#      into `tail|jq` lets the downstream close airflow's stdout early, which
#      makes airflow die with BrokenPipeError (exit 4) — a false failure.
#   2. Isolate the JSON with `grep '^\['` rather than `tail -1`, so jq never
#      sees a trailing log line ("Invalid numeric literal" parse errors).
json_line() { grep -E '^\[' | tail -1; }

# Airflow 3 CLI exposes the field as `run_id`; older CLIs used `dag_run_id`.
TRIGGER_OUT=$(airflow dags trigger "$DAG_NAME" --output json)
RUN_ID=$(printf '%s\n' "$TRIGGER_OUT" | json_line | jq -r '.[0].run_id // .[0].dag_run_id // empty')
if [ -z "$RUN_ID" ]; then
    echo "ERROR: could not parse a run_id from 'airflow dags trigger $DAG_NAME'. Raw output:" >&2
    printf '%s\n' "$TRIGGER_OUT" >&2
    exit 1
fi

start_time=$(date --iso-8601=seconds)
elapsed=0

while [ "$elapsed" -lt "$MAX_WAIT_SECONDS" ]; do
    RUNS_OUT=$(airflow dags list-runs "$DAG_NAME" --output json)
    STATUS=$(printf '%s\n' "$RUNS_OUT" | json_line | jq -r --arg rid "$RUN_ID" '.[] | select(.run_id == $rid) | .state')
    echo "$STATUS"

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
