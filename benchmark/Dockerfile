FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

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

COPY benchmark/experiment/scripts/run-dbt-core-per-model.sh /app/run-dbt-core-per-model.sh