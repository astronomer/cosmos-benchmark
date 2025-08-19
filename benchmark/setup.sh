#!/bin/bash

set -v
set -x
set -e

# Create a Kind cluster
kind create cluster
helm repo add apache-airflow https://airflow.apache.org
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus using Helm
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  --set prometheus.prometheusSpec.scrapeInterval="5s"

# Wait for Prometheus pod to be ready
kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/name=prometheus \
  -n monitoring --timeout=180s

# Expose Prometheus to the host so we can fetch metrics
kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090 &

# Build the docker image that will be used to run the experiments
cd ..; docker build -t benchmark:0.0.4 -f benchmark/Dockerfile .
kind load docker-image benchmark:0.0.4

# Create a namespace
kubectl create namespace airflow

## Install Airflow using Helm
helm install airflow apache-airflow/airflow --version 1.16.0 \
  --namespace airflow \
  -f values.yaml

kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090 &
kubectl port-forward svc/airflow-webserver 8080:8080 -n airflow &
