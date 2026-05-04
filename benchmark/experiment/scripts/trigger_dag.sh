#!/bin/bash

#set -v
#set -x
set -e

export PYTHONWARNINGS="ignore"

DAG_NAME="${DAG_NAME:-example_operator_build}"

# Airflow 3 CLI exposes the field as `run_id`; older CLIs used `dag_run_id`.
RUN_ID=$(airflow dags trigger $DAG_NAME --output json | tail -1 | jq '.[0].run_id // .[0].dag_run_id')

start_time=$(date --iso-8601=seconds)

while true; do
    #airflow dags list-runs -d $DAG_NAME --output json 
    #airflow dags list-runs -d $DAG_NAME --output json | jq '.[]'
    #airflow dags list-runs -d $DAG_NAME --output json | jq ".[] | select(.run_id == $RUN_ID)"    
    #airflow dags list-runs -d $DAG_NAME --output json | jq ".[] | select(.run_id == $RUN_ID) | .state"
    STATUS=$(airflow dags list-runs $DAG_NAME --output json | jq ".[] | select(.run_id == $RUN_ID) | .state")
    echo $STATUS
    
    if [[ $STATUS =~ "success" ]]; then
        echo "DAG run $RUN_ID succeeded"
        break
    elif [[ $STATUS =~ "failed" || $STATUS =~ "skipped" ]]; then
        echo "DAG run $RUN_ID ended with state: $STATUS"
        exit 400
    else
        echo "DAG run $RUN_ID is in state: $STATUS. Waiting..."
        sleep 5
    fi
done

end_time=$(date --iso-8601=seconds)

start_sec=$(date -d "$start_time" +%s)
end_sec=$(date -d "$end_time" +%s)
duration=$((end_sec - start_sec))

echo "Start: $start_time"
echo "End:   $end_time"
echo "Duration: ${duration} seconds"
