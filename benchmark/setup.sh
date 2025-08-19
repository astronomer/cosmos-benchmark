#!/bin/bash

set -v
set -x
set -e

kind create cluster

helm repo add apache-airflow https://airflow.apache.org
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus using Helm
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring --create-namespace \
  --set prometheus.prometheusSpec.scrapeInterval="5s"

docker build -t benchmark:0.0.1 -f benchmark/Dockerfile .
kind load docker-image benchmark:0.0.1

