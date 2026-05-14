FROM apache/airflow:3.2.0

USER root
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    jq \
    && rm -rf /var/lib/apt/lists/*

USER airflow

ENV AIRFLOW__COSMOS__PROPAGATE_LOGS=0
ENV AIRFLOW__COSMOS__ENABLE_CACHE=1
ENV AIRFLOW__COSMOS__CACHE_DIR=/tmp/
ENV AIRFLOW__CORE__DAGBAG_IMPORT_TIMEOUT=20000
ENV AIRFLOW__CORE__DAG_FILE_PROCESSOR_TIMEOUT=20000
ENV KEY_PATH=/opt/airflow/key.json

# dbt-bigquery + astronomer-cosmos on top of the official airflow image.
COPY benchmark/pre-process/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

WORKDIR /opt/airflow

# dbt project files sit at AIRFLOW_HOME root because cosmos_dags.py resolves
# the project path as Path(__file__).parent.parent (i.e. /opt/airflow/dags → /opt/airflow).
COPY --chown=airflow:0 dbt/fhir-dbt-analytics /opt/airflow
COPY --chown=airflow:0 benchmark/pre-process/profiles.yml /opt/airflow/profiles.yml
COPY --chown=airflow:0 benchmark/pre-process/key.json /opt/airflow/key.json

# Used by `dbt-core-run-per-model` Job-based experiment.
COPY --chown=airflow:0 benchmark/experiment/scripts/run-dbt-core-per-model.sh /opt/airflow/run-dbt-core-per-model.sh

# Used by run-complex-test.sh to trigger a DAG run from inside the api-server pod.
COPY --chown=airflow:0 benchmark/experiment/scripts/trigger_dag.sh /opt/airflow/trigger_dag.sh

# Pre-install dbt packages so Cosmos can parse the project at DAG import time
# without each pod needing to run `dbt deps` first.
RUN dbt deps --no-use-colors

# DAGs for both Job-based experiments and chart-based pods.
COPY --chown=airflow:0 benchmark/dags /opt/airflow/dags
