#!/bin/bash

#set -v
#set -x
set -e

kind delete cluster --name kind

# Wait for Docker container to be fully deleted
while docker ps -a --format '{{.Names}}' | grep -q "^kind-control-plane$"; do
  echo "Waiting for kind-control-plane container to be deleted..."
  sleep 2
done

# Wait for kubeconfig context to be gone
while kubectl config get-contexts -o name | grep -q "^kind-kind$"; do
  echo "Waiting for kube context 'kind-kind' to be removed..."
  sleep 2
done

echo "Kind cluster 'kind' fully deleted."
