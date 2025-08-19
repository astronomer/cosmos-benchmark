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
RUN pip install -r requirements.txt

# Create working directory
WORKDIR /app

# Copy project files into the container
COPY ../dbt/fhir-dbt-analytics /app
COPY profiles.yml /app/profiles.yml
COPY app.json /app/app.json

CMD ["airflow", "dags", "test", "example_dbt_dag"]
