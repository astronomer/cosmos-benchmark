#set -v
#set -x
#set -e

# === Configuration ===
# You can either:
# 1. Pass these as environment variables:
#       JOBS="dbt-core-build dbt-core-run" REPS=3 ./run-test.sh
# 2. Or set them below:

#JOBS="${JOBS:-dbt-core-seed dbt-core-test dbt-core-run dbt-core-build}"
#JOBS="${JOBS:-dbt-core-build dbt-core-run}"
#JOBS="${JOBS:-dbt-core-run-per-model}"
#REPS="${REPS:-3}"

JOBS="${JOBS:-airflow-test-buildoperator airflow-test-dbtdag}"
REPS="${REPS:-1}"

for job in $JOBS; do
  for ((i=1; i<=REPS; i++)); do
    echo -e "\n\n\n"
    echo "=== Run #$i for $job ==="
    echo Start time: $(date +"%Y-%m-%dT%H:%M:%S%z")
    kubectl delete job "$job" --ignore-not-found
    kubectl apply -f "experiment/$job.yaml"
    kubectl wait --for=condition=complete job/$job --timeout=7200s
    echo End time: $(date +"%Y-%m-%dT%H:%M:%S%z")
    sleep 40
    ./post-process/check-metrics.sh "$job"
    kubectl delete job "$job"
  done
done
