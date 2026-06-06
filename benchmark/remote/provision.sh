#!/usr/bin/env bash
#
# Provision a single GCE VM that runs the cosmos-benchmark WATCHER sweep
# (default: Cosmos 1.13.1 vs 1.14.2), then writes a CSV the laptop can fetch.
# The VM does all real work in its startup script (bootstrap.sh + run-sweep.sh
# from the repo), so this script's job is just to:
#
#   1. Sanity-check local prerequisites (gcloud, auth, key.json)
#   2. Upload key.json + sweep config to the VM via instance metadata
#   3. Create the VM with the right startup script wired in
#
# Once the VM is up, use monitor.sh to follow progress, fetch-results.sh to
# pull the CSV when the sweep finishes, and teardown.sh to delete the VM.
#
# All knobs are env-vars with sensible defaults — see README.md.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
KEY_FILE="${REPO_ROOT}/benchmark/pre-process/key.json"

# --- Config (override via env) -----------------------------------------------
GCP_PROJECT="${GCP_PROJECT:-astronomer-dag-authoring}"
GCP_ZONE="${GCP_ZONE:-us-central1-a}"
VM_NAME="${VM_NAME:-cosmos-bench}"
MACHINE_TYPE="${MACHINE_TYPE:-n2-standard-16}"
DISK_SIZE_GB="${DISK_SIZE_GB:-100}"
IMAGE_FAMILY="${IMAGE_FAMILY:-ubuntu-2204-lts}"
IMAGE_PROJECT="${IMAGE_PROJECT:-ubuntu-os-cloud}"

# Sweep config — baked into the VM's metadata, consumed by run-sweep.sh on the
# VM. Space-separated, evaluated as bash arrays by run-sweep.sh.
COSMOS_VERSIONS="${COSMOS_VERSIONS:-1.13.1 1.14.2}"
THREADS_VALUES="${THREADS_VALUES:-4 8 16}"
REPS="${REPS:-5}"

# Airflow base image + chart version — must be a matched pair (chart appVersion
# === image tag). Defaults track the 2026-05-15 published-results baseline.
# Override to e.g. AIRFLOW_BASE=apache/airflow:3.1.8 CHART_VERSION=1.20.0 when
# running a sweep that includes a pre-Airflow-3.2 Cosmos release (e.g. 1.13.1
# has a circular import on Airflow 3.2 — see benchmark/readme.md).
AIRFLOW_BASE="${AIRFLOW_BASE:-apache/airflow:3.2.0}"
CHART_VERSION="${CHART_VERSION:-1.21.0}"

# Where on GitHub the VM clones the benchmark repo from. Default tracks main;
# override to a feature branch while the remote scripts are still in review.
REPO_URL="${REPO_URL:-https://github.com/astronomer/cosmos-benchmark.git}"
REPO_BRANCH="${REPO_BRANCH:-main}"

# --- Local sanity checks -----------------------------------------------------
if ! command -v gcloud >/dev/null 2>&1; then
  echo "ERROR: gcloud CLI not found on PATH." >&2
  echo "       Either install it (brew install --cask gcloud-cli) and open a new" >&2
  echo "       shell, or point provision.sh at it explicitly:" >&2
  echo "         PATH=\"\$HOME/Downloads/google-cloud-sdk/bin:\$PATH\" ./provision.sh" >&2
  exit 1
fi

if [ ! -s "$KEY_FILE" ]; then
  echo "ERROR: $KEY_FILE is missing or empty." >&2
  echo "       Place a BigQuery service-account JSON key for project" >&2
  echo "       'astronomer-dag-authoring' at that path and re-run." >&2
  exit 1
fi

ACTIVE_ACCOUNT=$(gcloud auth list --filter=status:ACTIVE --format='value(account)' 2>/dev/null || true)
if [ -z "$ACTIVE_ACCOUNT" ]; then
  echo "ERROR: no active gcloud account. Run 'gcloud auth login' first." >&2
  exit 1
fi

# --- Build the inline startup script -----------------------------------------
# Kept deliberately small: clone the repo (with submodules), drop the BigQuery
# key into place, then hand off to bootstrap.sh in the repo. All sweep logic
# lives in version-controlled files, not in the VM's instance metadata.
STARTUP_SCRIPT=$(cat <<'STARTUP_EOF'
#!/usr/bin/env bash
set -euxo pipefail

# Stream everything to a known log path so the operator on the laptop can
# `gcloud compute ssh ... -- tail -f /var/log/cosmos-bench.log`.
exec > >(tee -a /var/log/cosmos-bench.log) 2>&1

# Pull config from instance metadata. Metadata server requires this header.
META="http://metadata.google.internal/computeMetadata/v1/instance/attributes"
fetch() { curl -fsSL -H "Metadata-Flavor: Google" "${META}/$1"; }

REPO_URL="$(fetch repo-url)"
REPO_BRANCH="$(fetch repo-branch)"
COSMOS_VERSIONS="$(fetch cosmos-versions)"
THREADS_VALUES="$(fetch threads-values)"
REPS="$(fetch reps)"
AIRFLOW_BASE="$(fetch airflow-base)"
CHART_VERSION="$(fetch chart-version)"

mkdir -p /opt/cosmos-bench
cd /opt/cosmos-bench

# Idempotent clone so re-running the startup script on an existing VM works.
if [ ! -d cosmos-benchmark/.git ]; then
  apt-get update
  apt-get install -y --no-install-recommends git ca-certificates
  git clone --recurse-submodules --branch "${REPO_BRANCH}" "${REPO_URL}" cosmos-benchmark
fi

# Drop the BigQuery key into the repo where the existing Dockerfile expects it.
fetch bigquery-key-json > cosmos-benchmark/benchmark/pre-process/key.json
chmod 600 cosmos-benchmark/benchmark/pre-process/key.json

# Hand off to the in-repo bootstrap. Exporting the sweep config so bootstrap.sh
# and run-sweep.sh can pick it up without re-reading metadata.
export COSMOS_VERSIONS THREADS_VALUES REPS AIRFLOW_BASE CHART_VERSION
exec bash cosmos-benchmark/benchmark/remote/bootstrap.sh
STARTUP_EOF
)

# Stage everything into a temp dir so --metadata-from-file can read it.
STAGE_DIR=$(mktemp -d)
trap 'rm -rf "$STAGE_DIR"' EXIT
printf '%s' "$STARTUP_SCRIPT" > "${STAGE_DIR}/startup-script"
cp "$KEY_FILE" "${STAGE_DIR}/bigquery-key-json"
printf '%s' "$REPO_URL"        > "${STAGE_DIR}/repo-url"
printf '%s' "$REPO_BRANCH"     > "${STAGE_DIR}/repo-branch"
printf '%s' "$COSMOS_VERSIONS" > "${STAGE_DIR}/cosmos-versions"
printf '%s' "$THREADS_VALUES"  > "${STAGE_DIR}/threads-values"
printf '%s' "$REPS"            > "${STAGE_DIR}/reps"
printf '%s' "$AIRFLOW_BASE"    > "${STAGE_DIR}/airflow-base"
printf '%s' "$CHART_VERSION"   > "${STAGE_DIR}/chart-version"

# Rough wall-clock estimate so the operator can size their patience to the
# actual matrix instead of a hardcoded blurb. Heuristic per rep is ~6 min
# (WATCHER threads=8 was 314s ± 9s in the 2026-05-15 baseline + ~45s of
# Prometheus polling + 60s inter-rep sleep). Bootstrap (kind+helm+image
# build) is ~15 min on a cold n2-custom-12-49152; each additional Cosmos
# version costs ~5 min for the image rebuild + helm rollout.
NUM_COSMOS=$(echo "$COSMOS_VERSIONS" | wc -w | tr -d ' ')
NUM_THREADS=$(echo "$THREADS_VALUES" | wc -w | tr -d ' ')
NUM_CELLS=$((NUM_COSMOS * NUM_THREADS))
EST_BOOTSTRAP=15
EST_REBUILDS=$(( (NUM_COSMOS - 1) * 5 ))
EST_RUNS=$(( NUM_CELLS * REPS * 6 ))
EST_MINUTES=$(( EST_BOOTSTRAP + EST_REBUILDS + EST_RUNS ))

cat <<EOF
About to create GCE VM with this config:

  project:          $GCP_PROJECT
  zone:             $GCP_ZONE
  name:             $VM_NAME
  machine type:     $MACHINE_TYPE     (16 vCPU / 64 GiB, ~\$0.78/hr in us-central1)
  disk:             ${DISK_SIZE_GB} GiB pd-ssd
  image:            $IMAGE_FAMILY ($IMAGE_PROJECT)
  account:          $ACTIVE_ACCOUNT

Sweep matrix (written into the VM via instance metadata):

  cosmos versions:  $COSMOS_VERSIONS
  threads values:   $THREADS_VALUES
  reps per cell:    $REPS
  airflow base:     $AIRFLOW_BASE
  chart version:    $CHART_VERSION
  repo branch:      $REPO_BRANCH   (from $REPO_URL)

Expected wall-clock: ~$EST_MINUTES min ($EST_BOOTSTRAP min bootstrap + \
$EST_REBUILDS min image rebuilds + \
$NUM_CELLS \xc3\x97 $REPS reps \xc3\x97 ~6 min = $EST_RUNS min sweep).
Hit Ctrl-C now to abort. Press ENTER to create the VM.
EOF
read -r _

# Existing VM with the same name in the same zone? Bail rather than overwrite.
if gcloud --project="$GCP_PROJECT" compute instances describe "$VM_NAME" \
     --zone="$GCP_ZONE" >/dev/null 2>&1; then
  echo "ERROR: VM ${VM_NAME} already exists in zone ${GCP_ZONE}." >&2
  echo "       Delete it first (./teardown.sh) or set VM_NAME to a new name." >&2
  exit 1
fi

# Minimal OAuth scopes: the only thing on the VM that talks to a Google API
# via the instance service account is the Ops Agent (logging + monitoring).
# BigQuery access goes through the mounted key.json, not the VM's SA, so we
# deliberately avoid the broad cloud-platform scope.
gcloud --project="$GCP_PROJECT" compute instances create "$VM_NAME" \
  --zone="$GCP_ZONE" \
  --machine-type="$MACHINE_TYPE" \
  --image-family="$IMAGE_FAMILY" \
  --image-project="$IMAGE_PROJECT" \
  --boot-disk-size="${DISK_SIZE_GB}GB" \
  --boot-disk-type=pd-ssd \
  --scopes=logging-write,monitoring-write \
  --metadata-from-file=\
"startup-script=${STAGE_DIR}/startup-script,"\
"bigquery-key-json=${STAGE_DIR}/bigquery-key-json,"\
"repo-url=${STAGE_DIR}/repo-url,"\
"repo-branch=${STAGE_DIR}/repo-branch,"\
"cosmos-versions=${STAGE_DIR}/cosmos-versions,"\
"threads-values=${STAGE_DIR}/threads-values,"\
"reps=${STAGE_DIR}/reps,"\
"airflow-base=${STAGE_DIR}/airflow-base,"\
"chart-version=${STAGE_DIR}/chart-version"

cat <<EOF

VM ${VM_NAME} created. Startup script is running now.

Next:
  Follow progress:   GCP_PROJECT=$GCP_PROJECT GCP_ZONE=$GCP_ZONE VM_NAME=$VM_NAME ./monitor.sh
  Fetch results:     GCP_PROJECT=$GCP_PROJECT GCP_ZONE=$GCP_ZONE VM_NAME=$VM_NAME ./fetch-results.sh
  Delete VM:         GCP_PROJECT=$GCP_PROJECT GCP_ZONE=$GCP_ZONE VM_NAME=$VM_NAME ./teardown.sh
EOF
