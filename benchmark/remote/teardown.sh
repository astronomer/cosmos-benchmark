#!/usr/bin/env bash
#
# Delete the GCE VM (and its boot disk) created by provision.sh.

set -euo pipefail

GCP_PROJECT="${GCP_PROJECT:-astronomer-dag-authoring}"
GCP_ZONE="${GCP_ZONE:-us-central1-a}"
VM_NAME="${VM_NAME:-cosmos-bench}"

if ! gcloud --project="$GCP_PROJECT" compute instances describe "$VM_NAME" \
     --zone="$GCP_ZONE" >/dev/null 2>&1; then
  echo "VM ${VM_NAME} not found in ${GCP_PROJECT}/${GCP_ZONE} — nothing to delete."
  exit 0
fi

cat <<EOF
About to DELETE GCE VM and its boot disk:
  project: $GCP_PROJECT
  zone:    $GCP_ZONE
  name:    $VM_NAME

Anything on the VM that hasn't been copied off (e.g. CSV results) will be lost.
Run ./fetch-results.sh first if you haven't already.

Ctrl-C to abort. Press ENTER to delete.
EOF
read -r _

gcloud --project="$GCP_PROJECT" compute instances delete "$VM_NAME" \
  --zone="$GCP_ZONE" --quiet
