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

# Overlay benchmark-local patches to upstream dbt project files. Each patch
# replaces a single upstream file to fix issues that cause flaky benchmark
# failures. See benchmark/patches/<filename> for the rationale per patch.
COPY --chown=airflow:0 benchmark/patches/unioned_thresholds.sql /opt/airflow/models/metadata/unioned_thresholds.sql

# Synthetic dbt project for the WATCHER sensor-memory benchmark.
# The project is generated *deterministically* (generate_project.py --rng-seed 42),
# so node count is a build knob (N_MODELS) rather than a committed fixture — this
# avoids checking in a 200MB+ / 22k-file tree for large scales. The default (3000)
# reuses the committed manifest as-is; any other value regenerates the models and
# re-parses to refresh target/manifest.json for LoadMode.DBT_MANIFEST.
#   docker build --build-arg N_MODELS=23000 ...   # large-manifest (23k-node) repro
ARG N_MODELS=3000
COPY --chown=airflow:0 dbt/synthetic_large_dbt_project /opt/airflow/dbt/synthetic_large_dbt_project
RUN if [ "$N_MODELS" != "3000" ]; then \
      cd /opt/airflow/dbt/synthetic_large_dbt_project && \
      rm -rf models target && \
      python scripts/generate_project.py --n-models "$N_MODELS" --rng-seed 42 && \
      dbt parse --profiles-dir . --project-dir . --no-use-colors ; \
    fi

# Used by `dbt-core-run-per-model` Job-based experiment.
COPY --chown=airflow:0 benchmark/experiment/scripts/run-dbt-core-per-model.sh /opt/airflow/run-dbt-core-per-model.sh

# Used by run-complex-test.sh to trigger a DAG run from inside the api-server pod.
COPY --chown=airflow:0 benchmark/experiment/scripts/trigger_dag.sh /opt/airflow/trigger_dag.sh

# Pre-install dbt packages so Cosmos can parse the project at DAG import time
# without each pod needing to run `dbt deps` first.
RUN dbt deps --no-use-colors

# DAGs for both Job-based experiments and chart-based pods.
COPY --chown=airflow:0 benchmark/dags /opt/airflow/dags
