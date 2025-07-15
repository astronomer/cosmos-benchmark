# Airflow 3 based image build
#FROM astrocrpublic.azurecr.io/runtime:3.0-4

# Airflow 2 based image build
FROM quay.io/astronomer/astro-runtime:12.8.0

USER root

RUN apt-get update -y && apt-get install -y git


RUN python -m venv dbt_venv && source dbt_venv/bin/activate && \
    pip install --no-cache-dir "dbt-core<1.10" dbt-adapters dbt-common dbt-extractor dbt-postgres dbt-snowflake dbt-semantic-interfaces dbt-bigquery && deactivate

# set a connection to the airflow metadata db to use for testing
ENV AIRFLOW_CONN_AIRFLOW_METADATA_DB=postgresql+psycopg2://postgres:postgres@postgres:5432/postgres


RUN pip install "dbt-core<1.10"
RUN pip install dbt-bigquery
RUN pip install dbt-postgres
RUN pip install dbt-snowflake
RUN pydantic==2.11.0

#ENV OPENLINEAGE_DISABLED=True
ENV AIRFLOW__CORE__LOAD_EXAMPLES=False
ENV AIRFLOW__CORE__TEST_CONNECTION=Enabled

USER astro
