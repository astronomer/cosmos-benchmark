#!/usr/bin/env bash
#
# Tail the sweep log on the GCE VM so you can watch progress in real time.
# Ctrl-C just disconnects — the sweep keeps running on the VM. Pair with
# fetch-results.sh when the sweep finishes.

set -euo pipefail

GCP_PROJECT="${GCP_PROJECT:-astronomer-dag-authoring}"
GCP_ZONE="${GCP_ZONE:-us-central1-a}"
VM_NAME="${VM_NAME:-cosmos-bench}"

exec gcloud --project="$GCP_PROJECT" compute ssh "$VM_NAME" \
  --zone="$GCP_ZONE" \
  --command='sudo tail -F /var/log/cosmos-bench.log'
