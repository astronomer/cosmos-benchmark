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

# Heavier packages.yml so `dbt deps` does enough work for the parse-time
# benchmark to surface a measurable difference between LoadModes.
COPY --chown=airflow:0 benchmark/patches/packages.yml /opt/airflow/packages.yml

# Used by `dbt-core-run-per-model` Job-based experiment.
COPY --chown=airflow:0 benchmark/experiment/scripts/run-dbt-core-per-model.sh /opt/airflow/run-dbt-core-per-model.sh

# Minimal Cosmos parse-time harness — constructs one DbtDag so the parse-time
# log line fires once. Used by ad-hoc benchmarks of LoadMode variants.
COPY --chown=airflow:0 benchmark/experiment/scripts/parse_one.py /opt/airflow/parse_one.py

# Build-time graph cache POC: parses dbt_ls.json once and pickles the result
# so runtime parses unpickle (~1.5 ms) instead of re-parsing JSON. Skips the
# folder-version hash entirely too. See the module docstring for the
# assumptions this relies on (image-immutability ⇒ no hash check needed).
COPY --chown=airflow:0 benchmark/experiment/scripts/dbt_graph_cache_poc.py /opt/airflow/dbt_graph_cache_poc.py

# Used by run-complex-test.sh to trigger a DAG run from inside the api-server pod.
COPY --chown=airflow:0 benchmark/experiment/scripts/trigger_dag.sh /opt/airflow/trigger_dag.sh

# Pre-generate every dbt artifact each LoadMode can reuse at parse time:
#   - dbt_packages/                                  (RUN dbt deps)
#   - target/manifest.json + partial_parse.msgpack   (RUN dbt parse)
#   - dbt_ls.json                                    (RUN dbt ls --output json)
# DAGs default to LoadMode.DBT_LS_FILE since it's the fastest upstream mode.
RUN dbt deps --no-use-colors
RUN dbt parse --no-use-colors
RUN dbt ls --output json --no-use-colors > /opt/airflow/dbt_ls.json

# POC: pre-bake the parsed graph as a sibling pickle alongside dbt_ls.json so
# runtime parses can unpickle instead of re-parsing JSON.
RUN python -c "import pickle; from pathlib import Path; from cosmos.dbt.graph import parse_dbt_ls_output; \
    nodes = parse_dbt_ls_output(Path('/opt/airflow'), open('/opt/airflow/dbt_ls.json').read()); \
    pickle.dump(nodes, open('/opt/airflow/dbt_ls.json.pkl', 'wb'), protocol=pickle.HIGHEST_PROTOCOL); \
    print(f'Pre-baked graph: {len(nodes)} nodes')"

# DAGs for both Job-based experiments and chart-based pods.
COPY --chown=airflow:0 benchmark/dags /opt/airflow/dags
