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
COPY benchmark/requirements.txt benchmark/requirements.txt
RUN pip install -r benchmark/requirements.txt

# Create working directory
WORKDIR /app

# Copy project files into the container
COPY dbt/fhir-dbt-analytics /app
COPY benchmark/profiles.yml /app/profiles.yml
COPY key.json /app/key.json

RUN dbt deps --profiles-dir /app

CMD ["dbt", "build"]
