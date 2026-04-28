Overview
========

This project aims to have a representative dbt project to evaluate the performance of [Cosmos](https://github.com/astronomer/astronomer-cosmos), a tool to run dbt Core or dbt Fusion projects as Apache Airflow DAGs and Task Groups with a few lines of code.

Project Contents
================

This project contains the following files and folders:

- **benchmark**: Contains step-by-step scripts to benchmark dbt Core and dbt Core with Cosmos using [fhir-dbt-analytics](https://github.com/google/fhir-dbt-analytics)
- **dags**: This folder contains the Python files that represent Airflow DAGs. These are simple DAGs that leverage Astronomer Cosmos.
- **dbt**: This folder contains the following dbt projects:
  * [fhir-dbt-analytics](https://github.com/google/fhir-dbt-analytics): A dbt Core project developed by Google, that interfaces with BigQuery. It contains:
    * 2 seeds
    * 52 sources
    * 185 models
  * [altered_jaffle_shop](https://github.com/astronomer/cosmos-benchmark/tree/main/dbt/altered_jaffle_shop): A custom dbt project designed to pre-compile dbt project and focus on specific custom models without any dbt-generated metadata dependencies. This project is based on a copy of the jaffle-shop project, with an additional four models that require significant time to run, enabling measurement of async DAG performance. 
    * The project includes one addition seed file (model_params.csv) — you can increase model transformation time by updating the values in this seed. 
    * More models can be generated automatically by running the bash command: `./benchmark/auto_generate_models.sh 2` (Here input 2 means generate 2 addition model for each custom model i.e generate 8 additional model).
- **Dockerfile**: This file contains a versioned Astro Runtime Docker image that provides a differentiated Airflow experience.
- **include**: This folder contains any additional files that you want to include as part of your project. In this particular case, it contains configuration files.
- **packages.txt**: Install OS-level packages needed for your project by adding them to this file. It is empty by default.
- **requirements.txt**: Install Python packages needed for your project by adding them to this file. It is empty by default.
- airflow_settings.yaml: Use this local-only file to specify Airflow Connections, Variables, and Pools instead of entering them in the Airflow UI as you develop DAGs in this project.

Run Your Project Locally
========================

Follow these three steps:

1. Initialise submodules by using:

```bash
git submodule init
git submodule update 
```

2. Start Airflow on your local machine by running:

```bash
astro dev start
```

This command will spin up five Docker containers on your machine, each for a different Airflow component:

- Postgres: Airflow's Metadata Database
- Scheduler: The Airflow component responsible for monitoring and triggering tasks
- DAG Processor: The Airflow component responsible for parsing DAGs
- API Server: The Airflow component responsible for serving the Airflow UI and API
- Triggerer: The Airflow component responsible for triggering deferred tasks

When all five containers are ready, the command will open the browser to the Airflow UI at http://localhost:8080/. You should also be able to access your Postgres Database at 'localhost:5432/postgres' with username 'postgres' and password 'postgres'.

Note: If you already have either of the above ports allocated, you can either [stop your existing Docker containers or change the port](https://www.astronomer.io/docs/astro/cli/troubleshoot-locally#ports-are-not-available-for-my-local-airflow-webserver).

3. Create a BigQuery connection in Airflow, with the name `bigquery_conn`. This can be done by following [these instructions](https://www.astronomer.io/docs/learn/connections/bigquery/). This is an example of how the setup can look, considering you pre-generated a [BigQuery service account JSON key file](https://cloud.google.com/iam/docs/keys-create-delete):
<img width="905" height="745" alt="example-bq-conn-ui" src="https://github.com/user-attachments/assets/243de7e3-77c6-4554-9941-9f68d2c27ffc" />

Deploy Your Project to Astronomer
=================================

If you have an Astronomer account, deploying it to Astro Cloud is simple. For deploying instructions, refer to Astronomer documentation: https://www.astronomer.io/docs/astro/deploy-code/
