#set -v
#set -x
#set -e


for job in dbt-core-run run-dbt-core-per-model; do
  for i in {1..3}; do
    echo "=== Run #$i for $job ==="
    echo Start time: $(date +"%Y-%m-%dT%H:%M:%S%z")
    kubectl delete job "$job" --ignore-not-found
    kubectl apply -f "$job.yaml"
    kubectl wait --for=condition=complete job/$job --timeout=3000s
    echo End time: $(date +"%Y-%m-%dT%H:%M:%S%z")
    sleep 40
    ./check-metrics.sh "$job"
    kubectl delete job "$job"
  done
done
