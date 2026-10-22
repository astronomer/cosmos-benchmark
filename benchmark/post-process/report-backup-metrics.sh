#!/bin/bash

# Append one JSON line per DAG run with the XCom backup timings that
# benchmark/dags/bench_backup_dags.py stores in Airflow Variables, plus the
# run and producer durations. Used by run-complex-test.sh when BACKUP_JSONL
# is set.
#
# Env vars:
#   BACKUP_JSONL  file to append to (required)
#   BENCH_LABEL   free-form label (optional)
#   NAMESPACE     k8s namespace (default: airflow)
#   KUBE_CONTEXT  kubectl context (default: kind-kind)

if [ -z "$1" ] || [ -z "${BACKUP_JSONL:-}" ]; then
  echo "Usage: BACKUP_JSONL=<file> $0 <dag-name>"
  exit 1
fi

DAG_NAME="$1"
NAMESPACE="${NAMESPACE:-airflow}"
KUBE_CONTEXT="${KUBE_CONTEXT:-kind-kind}"

API_POD=$(kubectl --context "$KUBE_CONTEXT" get pods -n "$NAMESPACE" -l component=api-server -o jsonpath="{.items[0].metadata.name}")
api_exec() { kubectl --context "$KUBE_CONTEXT" exec -n "$NAMESPACE" "$API_POD" -- "$@" 2>/dev/null; }

RUN_JSON=$(api_exec airflow dags list-runs "$DAG_NAME" --output json \
  | python3 -c "import json,sys;data=json.load(sys.stdin);print(json.dumps(data[0]) if data else '{}')")
RUN_ID=$(echo "$RUN_JSON" | jq -r '.run_id // .dag_run_id // empty')
if [ -z "$RUN_ID" ]; then
  echo "No DAG run found for ${DAG_NAME}"
  exit 1
fi
TASK_STATES_JSON=$(api_exec airflow tasks states-for-dag-run "$DAG_NAME" "$RUN_ID" --output json)
TRY1_KEY=$(python3 -c "import re,sys;print(re.sub(r'[^A-Za-z0-9_]', '_', f'bench_{sys.argv[1]}_{sys.argv[2]}_try1'))" "$DAG_NAME" "$RUN_ID")
TRY2_KEY=$(python3 -c "import re,sys;print(re.sub(r'[^A-Za-z0-9_]', '_', f'bench_{sys.argv[1]}_{sys.argv[2]}_try2'))" "$DAG_NAME" "$RUN_ID")
TRY1_JSON=$(api_exec airflow variables get "$TRY1_KEY" --default '{}' | tail -1)
TRY2_JSON=$(api_exec airflow variables get "$TRY2_KEY" --default '{}' | tail -1)

python3 - "$BACKUP_JSONL" "${BENCH_LABEL:-}" "$DAG_NAME" "$RUN_JSON" "$TASK_STATES_JSON" "$TRY1_JSON" "$TRY2_JSON" <<'PY'
import datetime, json, sys
path, label, dag_name, run_json, states_json, try1_json, try2_json = sys.argv[1:]
run = json.loads(run_json or "{}")
states = json.loads(states_json or "[]")


def seconds(start, end):
    if not start or not end:
        return None
    parse = lambda value: datetime.datetime.fromisoformat(value.replace("Z", "+00:00"))
    return round((parse(end) - parse(start)).total_seconds(), 1)


def load(text):
    try:
        return json.loads(text)
    except ValueError:
        return {}


producer = next((task for task in states if task.get("task_id") == "dbt_producer_watcher"), {})
row = {
    "label": label, "dag_id": dag_name, "run_id": run.get("run_id") or run.get("dag_run_id"), "state": run.get("state"),
    "duration_s": seconds(run.get("start_date"), run.get("end_date")),
    "producer_last_try_s": seconds(producer.get("start_date"), producer.get("end_date")), "producer_state": producer.get("state"),
    "tasks_total": len(states), "tasks_success": sum(1 for task in states if task.get("state") == "success"),
    "try1": load(try1_json), "try2": load(try2_json),
}
with open(path, "a") as handle:
    handle.write(json.dumps(row) + "\n")
print("Appended backup metrics to", path)
PY
