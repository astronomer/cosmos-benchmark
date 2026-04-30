#!/bin/bash

set -x
set -e

# Pin every kubectl/helm call below to the kind cluster's context so reruns
# can't accidentally target whatever cluster the user's current kube-context
# happens to point at.
KIND_CLUSTER="kind"
KUBE_CONTEXT="kind-${KIND_CLUSTER}"

# Create a Kind cluster (skip if it already exists)
if kind get clusters | grep -q "^${KIND_CLUSTER}$"; then
  echo "Kind cluster '${KIND_CLUSTER}' already exists, skipping creation."
else
  kind create cluster --name "${KIND_CLUSTER}"
fi

# Add the necessary Helm repositories (--force-update is idempotent)
helm repo add --force-update apache-airflow https://airflow.apache.org
helm repo add --force-update prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install or upgrade Prometheus using Helm
helm --kube-context "${KUBE_CONTEXT}" upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  --set prometheus.prometheusSpec.scrapeInterval="5s"

# Wait for Prometheus pod to be ready
kubectl --context "${KUBE_CONTEXT}" wait --for=condition=ready pod \
  -l app.kubernetes.io/name=prometheus \
  -n monitoring --timeout=180s

# Expose Prometheus to the host so we can fetch metrics
# (kill any existing port-forward on 9090 before starting a new one)
if lsof -ti:9090 >/dev/null 2>&1; then
  echo "Port 9090 already in use, killing existing process(es)."
  lsof -ti:9090 | xargs kill -9 || true
fi
kubectl --context "${KUBE_CONTEXT}" port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090 &

# Build the docker image that will be used to run the experiments
cd ..; docker build -t benchmark:0.0.3 -f benchmark/Dockerfile .
kind load docker-image benchmark:0.0.3
