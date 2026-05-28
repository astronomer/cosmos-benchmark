#!/usr/bin/env bash
#
# Runs on the GCE VM as root, kicked off by provision.sh's inline startup
# script. Installs the tools the existing benchmark scripts need (Docker, kind,
# kubectl, helm, python3, jq, lsof) and then hands off to run-sweep.sh.
#
# Inputs (exported by the inline startup script before invoking us):
#   COSMOS_VERSIONS   space-separated list of astronomer-cosmos versions
#   THREADS_VALUES    space-separated list of dbt threads values
#   REPS              integer reps per (cosmos, threads) cell

set -euxo pipefail

: "${COSMOS_VERSIONS:?must be set by provision.sh startup-script}"
: "${THREADS_VALUES:?must be set by provision.sh startup-script}"
: "${REPS:?must be set by provision.sh startup-script}"

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
