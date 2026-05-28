#!/usr/bin/env bash
#
# Pull the sweep's CSV and summary markdown from the GCE VM into
# benchmark/results/ on the laptop. By default, blocks until the sweep's
# SWEEP_DONE sentinel appears on the VM; pass --no-wait to skip the wait
# (useful for grabbing partial results from an in-progress sweep).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_RESULTS="${SCRIPT_DIR}/../results"

GCP_PROJECT="${GCP_PROJECT:-astronomer-dag-authoring}"
GCP_ZONE="${GCP_ZONE:-us-central1-a}"
VM_NAME="${VM_NAME:-cosmos-bench}"

WAIT=1
if [ "${1:-}" = "--no-wait" ]; then
  WAIT=0
fi

REMOTE_RESULTS="/opt/cosmos-bench/results"
SENTINEL="${REMOTE_RESULTS}/SWEEP_DONE"

ssh_exec() {
  gcloud --project="$GCP_PROJECT" compute ssh "$VM_NAME" \
    --zone="$GCP_ZONE" --command="$1"
}

if [ "$WAIT" = "1" ]; then
  echo "Waiting for ${SENTINEL} on ${VM_NAME}... (Ctrl-C to abort; sweep keeps running)"
  while ! ssh_exec "test -f ${SENTINEL}" >/dev/null 2>&1; do
    sleep 30
  done
  echo "Sentinel found. Fetching results."
fi

mkdir -p "$LOCAL_RESULTS"

# Resolve the symlinks on the VM to their real targets so scp gets the actual
# files, not the symlinks (gcloud scp doesn't follow them across the wire).
LATEST_CSV=$(ssh_exec "readlink -f ${REMOTE_RESULTS}/sweep-latest.csv" 2>/dev/null | tr -d '\r')
LATEST_MD=$(ssh_exec  "readlink -f ${REMOTE_RESULTS}/sweep-latest.md"  2>/dev/null | tr -d '\r')

if [ -z "$LATEST_CSV" ]; then
  echo "ERROR: ${REMOTE_RESULTS}/sweep-latest.csv missing on the VM." >&2
  echo "       Has the sweep started writing yet? Check monitor.sh." >&2
  exit 1
fi

gcloud --project="$GCP_PROJECT" compute scp \
  --zone="$GCP_ZONE" \
  "${VM_NAME}:${LATEST_CSV}" "${VM_NAME}:${LATEST_MD}" \
  "$LOCAL_RESULTS/"

echo
echo "Fetched into ${LOCAL_RESULTS}/:"
ls -lh "$LOCAL_RESULTS/" | tail -n +2
