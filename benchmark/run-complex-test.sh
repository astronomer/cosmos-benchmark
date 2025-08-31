set -v
set -x
set -e

for RUN_DAG_NAME in example_dbt_dag; do
#for RUN_DAG_NAME in example_dbt_dag example_operator_build; do
#for RUN_DAG_NAME in example_operator_build; do

  for i in {1..1}; do

    export DAG_NAME=$RUN_DAG_NAME

    ./delete-cluster.sh 
    ./create-cluster.sh


    # Wait for webserver, scheduler, triggerer deployments
    for deploy in airflow-webserver airflow-scheduler ; do
       kubectl wait --for=condition=Available deployment/$deploy -n airflow --timeout=300s
    done

    # Wait for worker pods (CeleryExecutor)
    kubectl wait --for=condition=Ready pod -l component=worker -n airflow --timeout=300s

    kubectl exec -it -n airflow $(kubectl get pods -n airflow -l component=webserver -o jsonpath="{.items[0].metadata.name}") -- bash trigger_dag.sh

    sleep 40
    #./check-complex-metrics.sh 
  done
done
