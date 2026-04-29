#!/bin/bash

set -v
set -x
set -e

# Create a Kind cluster
kind create cluster

# Add the necessary Helm repositories
helm repo add apache-airflow https://airflow.apache.org
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus using Helm
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  --set prometheus.prometheusSpec.scrapeInterval="5s"

# Wait for the Prometheus pod to be created by the operator (helm install
# returns before the StatefulSet/pod exist), then wait for it to be ready.
until kubectl get pod -l app.kubernetes.io/name=prometheus -n monitoring 2>/dev/null | grep -q prometheus; do
  echo "Waiting for Prometheus pod to be created..."
  sleep 2
done
kubectl wait --for=condition=ready pod \
  -l app.kubernetes.io/name=prometheus \
  -n monitoring --timeout=180s

# Expose Prometheus to the host so we can fetch metrics
kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090 &

# Build the docker image that will be used to run the experiments
cd ..; docker build -t benchmark:0.0.3 -f benchmark/Dockerfile .
kind load docker-image benchmark:0.0.3
