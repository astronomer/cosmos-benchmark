#!/bin/bash
#
# Estimate how far through the airflow-test-dbtdag run the cluster is.
#
# Primary mode (no args): inspect the airflow-test-dbtdag pod logs, count the
# distinct dbt models that have already been marked SUCCESS, and report
# completed / remaining out of the total executable nodes in dbt-ls-output.json.
# This is an honest "what's actually been run" number, not a guess.
#
# Fallback mode: if the pod isn't available you can pass a model name and the
# script will fall back to an *approximate* topological-position estimate.
# That estimate is rough — at any DAG layer multiple models are eligible and
# Airflow picks one based on task-id ordering, so the same model can land at
# different positions depending on tie-breaking. Use the primary mode when you
# can.
#
# Usage:
#   ./progress.sh                          # primary: counts SUCCESS lines in pod logs
#   ./progress.sh <model_name>             # fallback: topo-position estimate
#   POD=airflow-test-dbtdag-abc ./progress.sh   # use a specific pod

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DBT_LS_JSON="${DBT_LS_JSON:-$REPO_ROOT/dbt/fhir-dbt-analytics-dbt-ls-output.json}"
KUBE_CONTEXT="${KUBE_CONTEXT:-kind-kind}"
JOB_NAME="${JOB_NAME:-airflow-test-dbtdag}"
DAG_ID="${DAG_ID:-example_dbt_dag}"

if [ ! -f "$DBT_LS_JSON" ]; then
  echo "ERROR: dbt ls output not found at $DBT_LS_JSON" >&2
  echo "       Generate it with: cd dbt/fhir-dbt-analytics && dbt ls --output json > dbt-ls-output.json" >&2
  exit 1
fi

USER_MODEL="${1:-}"

# POD can be set explicitly to override auto-detection, e.g.:
#   POD=airflow-test-dbtdag-abcde ./progress.sh
if [ -n "${POD:-}" ]; then
  echo "pod (from \$POD): $POD"
else
  POD="$(kubectl --context "$KUBE_CONTEXT" get pods -l "job-name=$JOB_NAME" \
           -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
  if [ -n "$POD" ]; then
    echo "pod (auto-detected via job-name=$JOB_NAME): $POD"
  fi
fi

if [ -n "$POD" ]; then
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
  exit 0
fi

# Fallback: no pod, need a model name to do a topo-position estimate.
if [ -z "$USER_MODEL" ]; then
  echo "ERROR: no pod found for job $JOB_NAME in context $KUBE_CONTEXT," >&2
  echo "       and no model name passed for the fallback estimate." >&2
  echo "       Usage: $0 [<model_name>]" >&2
  exit 1
fi

echo "WARN: no pod found, falling back to approximate topological-position estimate." >&2
echo "      This is rough — see the script header for caveats." >&2

python3 - "$DBT_LS_JSON" "$USER_MODEL" <<'PY'
import json, sys
from graphlib import TopologicalSorter

ls_path, target_short = sys.argv[1], sys.argv[2]

nodes = []
with open(ls_path) as f:
    for line in f:
        line = line.strip()
        if not line or not line.startswith("{"):
            continue
        nodes.append(json.loads(line))

by_id = {n["unique_id"]: n for n in nodes}
executable = {uid: n for uid, n in by_id.items() if n["resource_type"] in {"model", "seed"}}
graph = {
    uid: {d for d in n.get("depends_on", {}).get("nodes", []) if d in executable}
    for uid, n in executable.items()
}

ordered = list(TopologicalSorter(graph).static_order())
candidates = [uid for uid in ordered if uid.split(".")[-1] == target_short]
if not candidates:
    print(f"ERROR: model '{target_short}' not found in {ls_path}", file=sys.stderr)
    sys.exit(1)
target_full = candidates[0]
idx = ordered.index(target_full)
total = len(ordered)
done = idx + 1

print(f"executable nodes (models+seeds): {total}")
print(f"target:                          {target_full}")
print(f"topological position (~):        {done} of {total}")
print(f"percent done (~):                {done / total * 100:.1f}%")
print(f"percent remaining (~):           {(total - done) / total * 100:.1f}%")
PY
