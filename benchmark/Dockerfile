FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV AIRFLOW_HOME="/app"
ENV AIRFLOW__COSMOS__PROPAGATE_LOGS=0
ENV AIRFLOW__COSMOS__ENABLE_CACHE=1
ENV AIRFLOW__COSMOS__CACHE_DIR=/tmp/
ENV AIRFLOW__CORE__DAGBAG_IMPORT_TIMEOUT=20000
ENV AIRFLOW__CORE__DAG_FILE_PROCESSOR_TIMEOUT=20000

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN pip install --upgrade pip

# Install airflow dependencies
COPY benchmark/pre-process/requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

# Create working directory
WORKDIR /app

# Copy project files into the container
COPY dbt/fhir-dbt-analytics /app
COPY benchmark/pre-process/profiles.yml /app/profiles.yml
COPY benchmark/pre-process/key.json /app/key.json

# Pre-install dbt packages so cosmos can parse the project at DAG-load time
# without needing to run `dbt deps` at runtime (cosmos is configured with
# install_dbt_deps=False to keep benchmark numbers focused on execution).
RUN dbt deps --project-dir /app

# Specific for `dbt-core-run-per-model`
COPY benchmark/experiment/scripts/run-dbt-core-per-model.sh /app/run-dbt-core-per-model.sh

# Specific for `airflow-test-buildoperator` and `airflow-test-dbtdag`
COPY benchmark/dags /app/dags
RUN airflow db reset -y
