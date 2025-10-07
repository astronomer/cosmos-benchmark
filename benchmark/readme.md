Benchmark
=========

The goal of this project is to help comparing and analysing the performance of running dbt Core, dbt Cloud and dbt in Airflow with Astronomer Cosmos. As a starting point the tests are being run using the Airflow Helmchart - but the idea is that in future we'll extend these tests to also compare the performance in Astro Cloud.

The perfomance is analysed from three perspectives:

* Time to complete the execution of the DAG
* Total memory consumed
* Total vCPU consumed

These metrics can be extended over time. One component we would like to evaluate in future, fpr 

For the tests to be fair, except for dbt Cloud (since we don't control it), we will run them using a similar "hardware". The tests will be run in a pod in a Kubernetes cluster with the same values for resources and limits.

As a starting point, we are running the tests against a local Kubernetes cluster, but if we want a further level of isolation, we could run them against any managed cluster.

Requirements
------------

Install the following tools:
* Docker or equivalent tool.
* Kind

Create a file called `key.json` inside the folder `benchmark/pre-process`, which contains the credentials to access the BigQuery instance of interest. While we are running locally, this approach is acceptable. If we are using a hosted K8s cluster, we should use K8s secrets or another more secure approach.

Analysing performance
---------------------

As a first step, we'll analyse dbt-core commands performance.
This approach will be extended to run Airflow.

To run this analysis, run the following scripts:

1. First, setup the K8s cluster with Kind, build the docker image, and make it available in the K8s cluster. Also install prometheus, so we can fetch metrics:

```
./setup.sh
```

2. Second, for each test case of interest, create a K8s job. Execute it in the Kind cluster and collect the metrics for that job:

```
./run-test.sh
```

Results
-------

The data printed to the console has been copied to this Google Spreadsheet:
https://docs.google.com/spreadsheets/d/10c6hMjwBJZ1DybiJT8o0TApVPyk-oPuJCY01bj2zC0A/edit?gid=0#gid=0
