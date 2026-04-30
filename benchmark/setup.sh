#!/bin/bash

set -x
set -e

# Create a Kind cluster (skip if it already exists)
if kind get clusters | grep -q '^kind$'; then
  echo "Kind cluster 'kind' already exists, skipping creation."
else
  kind create cluster
fi

# Add the necessary Helm repositories (--force-update is idempotent)
helm repo add --force-update apache-airflow https://airflow.apache.org
helm repo add --force-update prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install or upgrade Prometheus using Helm
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  --set prometheus.prometheusSpec.scrapeInterval="5s"

# Wait for Prometheus pod to be ready
kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/name=prometheus \
  -n monitoring --timeout=180s

# Expose Prometheus to the host so we can fetch metrics
# (kill any existing port-forward on 9090 before starting a new one)
if lsof -ti:9090 >/dev/null 2>&1; then
  echo "Port 9090 already in use, killing existing process(es)."
  lsof -ti:9090 | xargs kill -9 || true
fi
kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090 &

# Build the docker image that will be used to run the experiments
cd ..; docker build -t benchmark:0.0.3 -f benchmark/Dockerfile .
kind load docker-image benchmark:0.0.3
