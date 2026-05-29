#!/usr/bin/env bash
#
# Runs on the GCE VM as root, kicked off by provision.sh's inline startup
# script. Installs the tools the existing benchmark scripts need (Docker, kind,
# kubectl, helm, python3, jq, lsof) plus the Google Cloud Ops Agent (so VM
# memory metrics show up in Cloud Monitoring) and then hands off to run-sweep.sh.
#
# Inputs (exported by the inline startup script before invoking us):
#   COSMOS_VERSIONS   space-separated list of astronomer-cosmos versions
#   THREADS_VALUES    space-separated list of dbt threads values
#   REPS              integer reps per (cosmos, threads) cell
#   AIRFLOW_BASE      Dockerfile FROM image (e.g. apache/airflow:3.2.0)
#   CHART_VERSION     apache-airflow Helm chart version (e.g. 1.21.0)

set -euxo pipefail

: "${COSMOS_VERSIONS:?must be set by provision.sh startup-script}"
: "${THREADS_VALUES:?must be set by provision.sh startup-script}"
: "${REPS:?must be set by provision.sh startup-script}"
: "${AIRFLOW_BASE:?must be set by provision.sh startup-script}"
: "${CHART_VERSION:?must be set by provision.sh startup-script}"

REPO_DIR="/opt/cosmos-bench/cosmos-benchmark"
KIND_VERSION="v0.23.0"
HELM_VERSION="v3.15.0"

# --- System packages ---------------------------------------------------------
# `lsof` and `jq` are dependencies of the existing setup.sh / post-process
# scripts; python3 is preinstalled on ubuntu-2204-lts but we double-check.
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates curl gnupg jq lsof python3 python3-pip \
  apt-transport-https software-properties-common

# --- Google Cloud Ops Agent (VM memory + process metrics) -------------------
# Without this, Cloud Monitoring only shows CPU/disk/network for the VM. The
# Ops Agent backfills memory utilisation, swap, paging, and per-process
# stats — useful for comparing sweep runs at the VM level (independent of the
# in-cluster Prometheus stack the benchmark itself uses).
if ! systemctl is-active --quiet google-cloud-ops-agent 2>/dev/null; then
  curl -fsSL -o /tmp/add-google-cloud-ops-agent-repo.sh \
    https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
  bash /tmp/add-google-cloud-ops-agent-repo.sh --also-install
fi

# --- Docker via official convenience script ---------------------------------
if ! command -v docker >/dev/null 2>&1; then
  curl -fsSL https://get.docker.com | sh
fi
systemctl enable --now docker

# --- kind --------------------------------------------------------------------
if ! command -v kind >/dev/null 2>&1; then
  curl -fsSL -o /usr/local/bin/kind \
    "https://kind.sigs.k8s.io/dl/${KIND_VERSION}/kind-linux-amd64"
  chmod +x /usr/local/bin/kind
fi

# --- kubectl -----------------------------------------------------------------
if ! command -v kubectl >/dev/null 2>&1; then
  # Pull the latest stable kubectl. Pinning isn't important — every kubectl
  # call in the benchmark scripts targets a kind cluster we create here.
  KCTL_VER="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"
  curl -fsSL -o /usr/local/bin/kubectl \
    "https://dl.k8s.io/release/${KCTL_VER}/bin/linux/amd64/kubectl"
  chmod +x /usr/local/bin/kubectl
fi

# --- helm --------------------------------------------------------------------
if ! command -v helm >/dev/null 2>&1; then
  curl -fsSL "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" \
    | tar -xz -C /tmp linux-amd64/helm
  mv /tmp/linux-amd64/helm /usr/local/bin/helm
  chmod +x /usr/local/bin/helm
fi

# --- Hand off to the in-repo sweep driver -----------------------------------
cd "${REPO_DIR}/benchmark"
exec bash remote/run-sweep.sh
