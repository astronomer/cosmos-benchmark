Overview
========

This project aims to have a representative dbt project to evaluate the performance of [Cosmos](https://github.com/astronomer/astronomer-cosmos), a tool to run dbt Core or dbt Fusion projects as Apache Airflow DAGs and Task Groups with a few lines of code.

Project Contents
================

This project contains the following files and folders:

- **dags**: This folder contains the Python files that represent Airflow DAGs. These are simple DAGs that leverage Astronomer Cosmos.
- **dbt**: This folder contains the following dbt projects:
  * [fhir-dbt-analytics](https://github.com/google/fhir-dbt-analytics#): A dbt Core project developed by Google, that interfaces with BigQuery. It contains:
    * 2 seeds
    * 52 sources
    * 185 models
- **Dockerfile**: This file contains a versioned Astro Runtime Docker image that provides a differentiated Airflow experience.
- **include**: This folder contains any additional files that you want to include as part of your project. In this particular case, it contains configuration files.
- **packages.txt**: Install OS-level packages needed for your project by adding them to this file. It is empty by default.
- **requirements.txt**: Install Python packages needed for your project by adding them to this file. It is empty by default.
- airflow_settings.yaml: Use this local-only file to specify Airflow Connections, Variables, and Pools instead of entering them in the Airflow UI as you develop DAGs in this project.

Run Your Project Locally
========================

Initialise submodules by using:

```bash
git submodule init
```

Start Airflow on your local machine by running:

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

Deploy Your Project to Astronomer
=================================

If you have an Astronomer account, deploying it to Astro Cloud is simple. For deploying instructions, refer to Astronomer documentation: https://www.astronomer.io/docs/astro/deploy-code/
