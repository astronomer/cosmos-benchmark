#!/bin/bash
#
# Reproduce the dbt_graph_cache_poc benchmark.
#
# Builds the benchmark image if needed, then runs the parse-time benchmark
# twice: once with the POC disabled (DBT_LS_FILE baseline) and once with the
# POC enabled (graph cache + static folder hash). Reports min/max/mean/median
# for both runs and the speedup.
#
# Usage:
#   ./measure-poc.sh              # 5 runs each
#   ./measure-poc.sh 10           # 10 runs each
#   ./measure-poc.sh 5 rebuild    # force a rebuild before measuring
#
# Requirements: docker + python3 on PATH. No k8s needed.

set -euo pipefail

RUNS="${1:-5}"
REBUILD="${2:-}"
IMAGE="benchmark:0.0.3"

# Resolve repo root from this script's location so the build context is right.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

if [[ "$REBUILD" == "rebuild" ]] || ! docker image inspect "$IMAGE" >/dev/null 2>&1; then
  echo "==> Building $IMAGE (this can take a few minutes)"
  docker build -t "$IMAGE" -f "$REPO_ROOT/benchmark/Dockerfile" "$REPO_ROOT" >/dev/null
fi

CACHE_ENV=(
  -e AIRFLOW__COSMOS__ENABLE_CACHE=0
  -e AIRFLOW__COSMOS__ENABLE_CACHE_PARTIAL_PARSE=0
  -e AIRFLOW__COSMOS__ENABLE_CACHE_PACKAGE_LOCKFILE=0
  -e AIRFLOW__COSMOS__ENABLE_CACHE_DBT_LS=0
  -e AIRFLOW__COSMOS__ENABLE_CACHE_DBT_YAML_SELECTORS=0
  -e AIRFLOW__COSMOS__ENABLE_CACHE_PROFILE=0
)

# Single-DAG parse harness — runs inside each fresh container.
PARSE_CMD='
airflow db migrate >/dev/null 2>&1
cd /opt/airflow
python -c "
import logging; logging.basicConfig(level=logging.INFO, format=\"%(message)s\")
import sys; sys.path.insert(0, \"/opt/airflow/dags\")
import cosmos_dags
" 2>&1 | grep "to parse the dbt project for DAG using LoadMode" | head -1 \
       | grep -oE "It took [0-9.]+s" | grep -oE "[0-9.]+"
'

run_label() {
  local label="$1" disable_poc="$2"
  echo "==> $label"
  local times=()
  for ((i=1; i<=RUNS; i++)); do
    local env_args=("${CACHE_ENV[@]}")
    if [[ "$disable_poc" == "1" ]]; then
      env_args+=(-e COSMOS_GRAPH_CACHE_POC_DISABLE=1)
    fi
    local t
    t=$(docker run --rm "${env_args[@]}" "$IMAGE" bash -c "$PARSE_CMD")
    printf "  Run #%d: %ss\n" "$i" "$t"
    times+=("$t")
  done
  # Emit a Python-list literal of the times for the summary step below.
  echo -n "  Summary: "
  python3 -c "
import statistics
t = [$(IFS=,; echo "${times[*]}")]
print(f'mean={statistics.mean(t)*1000:.2f}ms median={statistics.median(t)*1000:.2f}ms '
      f'min={min(t)*1000:.2f}ms max={max(t)*1000:.2f}ms stdev={statistics.stdev(t)*1000:.2f}ms')
"
  # Persist the mean for the final speedup compare.
  local outfile
  if [[ "$disable_poc" == "1" ]]; then outfile=/tmp/_mean_without_poc.txt; else outfile=/tmp/_mean_with_poc.txt; fi
  python3 -c "
import statistics
t = [$(IFS=,; echo "${times[*]}")]
print(statistics.mean(t))
" > "$outfile"
  echo
}

run_label "WITHOUT POC (DBT_LS_FILE baseline, $RUNS fresh containers)" "1"
run_label "WITH POC    (graph cache + static folder hash, $RUNS fresh containers)" "0"

python3 -c "
without_poc = float(open('/tmp/_mean_without_poc.txt').read().strip())
with_poc    = float(open('/tmp/_mean_with_poc.txt').read().strip())
print(f'==> Speedup: {without_poc / with_poc:.1f}x  '
      f'({without_poc*1000:.2f}ms → {with_poc*1000:.2f}ms)')
"
