#!/bin/bash
#
# Estimate how far through the airflow-test-dbtdag run the cluster is.
#
# Inspects the airflow-test-dbtdag pod logs, counts the distinct dbt models
# that have been marked SUCCESS, and reports completed / remaining out of the
# total executable nodes in the checked-in dbt-ls snapshot.
#
# Usage:
#   ./progress.sh                              # auto-detects the pod via job-name
#   POD=airflow-test-dbtdag-abc ./progress.sh  # use a specific pod

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DBT_LS_JSON="${DBT_LS_JSON:-$REPO_ROOT/dbt/fhir-dbt-analytics-dbt-ls-output.json}"
KUBE_CONTEXT="${KUBE_CONTEXT:-kind-kind}"
JOB_NAME="${JOB_NAME:-airflow-test-dbtdag}"
DAG_ID="${DAG_ID:-example_dbt_dag}"

if [ ! -f "$DBT_LS_JSON" ]; then
  echo "ERROR: dbt ls output not found at $DBT_LS_JSON" >&2
  echo "       See benchmark/readme.md for how to regenerate it." >&2
  exit 1
fi

# POD can be set explicitly to override auto-detection, e.g.:
#   POD=airflow-test-dbtdag-abcde ./progress.sh
if [ -n "${POD:-}" ]; then
  echo "pod (from \$POD): $POD"
else
  POD="$(kubectl --context "$KUBE_CONTEXT" get pods -l "job-name=$JOB_NAME" \
           -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
  if [ -z "$POD" ]; then
    echo "ERROR: no pod found for job $JOB_NAME in context $KUBE_CONTEXT." >&2
    echo "       The job may not be running yet, or it may have already finished and been deleted." >&2
    echo "       Pass POD=<name> to inspect a specific pod." >&2
    exit 1
  fi
  echo "pod (auto-detected via job-name=$JOB_NAME): $POD"
fi

LOGS_TMP="$(mktemp)"
trap 'rm -f "$LOGS_TMP"' EXIT
if ! kubectl --context "$KUBE_CONTEXT" logs "$POD" > "$LOGS_TMP" 2>/dev/null; then
  echo "ERROR: failed to fetch logs for pod $POD" >&2
  exit 1
fi

python3 - "$DBT_LS_JSON" "$LOGS_TMP" "$DAG_ID" <<'PY'
import json, re, sys

ls_path, log_path, dag_id = sys.argv[1], sys.argv[2], sys.argv[3]

nodes = []
with open(ls_path) as f:
    for line in f:
        line = line.strip()
        if not line or not line.startswith("{"):
            continue
        nodes.append(json.loads(line))

executable = [n for n in nodes if n["resource_type"] in {"model", "seed"}]
model_names = {n["unique_id"].split(".")[-1] for n in executable}
total = len(model_names)

SUFFIX_RE = re.compile(r"_(run|seed|test|build)$")
def to_model(task_id: str) -> str:
    return SUFFIX_RE.sub("", task_id)

completed_tasks = set()
last_touched = None

success_re = re.compile(r"Marking task as SUCCESS\..*task_id=([A-Za-z0-9_]+)")
touch_re = re.compile(re.escape(dag_id) + r"\.([A-Za-z0-9_]+)")

with open(log_path) as f:
    for line in f:
        m = success_re.search(line)
        if m:
            completed_tasks.add(m.group(1))
        m = touch_re.search(line)
        if m:
            last_touched = m.group(1)

completed_models = {to_model(t) for t in completed_tasks if to_model(t) in model_names}
done = len(completed_models)
remaining = total - done

current_model = None
if last_touched:
    candidate = to_model(last_touched)
    if candidate in model_names and candidate not in completed_models:
        current_model = candidate

print(f"executable nodes (models+seeds):        {total}")
print(f"completed (Marking task as SUCCESS):    {done}")
print(f"remaining:                              {remaining}")
print(f"percent done:                           {done / total * 100:.1f}%")
if current_model:
    print(f"currently running (best guess):         {current_model}")
elif last_touched:
    print(f"last touched task in logs:              {last_touched} (already completed or non-model)")

unknown_completed = {to_model(t) for t in completed_tasks} - model_names
if unknown_completed:
    print(f"note: {len(unknown_completed)} completed task(s) didn't map to a known model name "
          f"(e.g. {sorted(unknown_completed)[:3]}); they were ignored.")
PY
