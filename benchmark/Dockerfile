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
RUN pip install -r requirements.txt

# Create working directory
WORKDIR /app

# Copy project files into the container
COPY ../dbt/fhir-dbt-analytics /app
COPY profiles.yml /app/profiles.yml
COPY app.json /app/app.json
