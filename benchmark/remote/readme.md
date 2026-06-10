Remote benchmark on GCP
=======================

Provision a GCE VM, run a Cosmos-version × dbt-threads sweep on it, pull
results back. See the _Running benchmarks remotely on GCP_ section of
[`../readme.md`](../readme.md) for the full reference (machine types,
env-var overrides, cost estimate, internals).

Quickstart (from this directory):

```
./provision.sh           # creates the VM and kicks off the sweep
./monitor.sh             # tails the on-VM sweep log
./fetch-results.sh       # waits for SWEEP_DONE, then scps CSV + .md into ../results/
./teardown.sh            # deletes the VM and its boot disk
```

Defaults:

* GCP project `astronomer-dag-authoring`, zone `us-central1-a`
* VM `n2-standard-16` (16 vCPU / 64 GiB, ~$0.78/hr) — sized to fit the
  9-consumer + 1-producer pool; see the main readme for the cpu-reservation
  math and the smaller `n2-custom-12-49152` alternative
* Sweep `cosmos ∈ {1.13.1, 1.14.2}` × `threads ∈ {4, 8, 16}` × `5 reps`
  → ~3 hrs of VM time (≈ $2.35)

Override via env vars on `provision.sh` (e.g. `MACHINE_TYPE=n2-standard-32
COSMOS_VERSIONS="1.13.1 1.14.0 1.14.2" ./provision.sh`). `monitor.sh`,
`fetch-results.sh`, and `teardown.sh` all read the same `GCP_PROJECT`,
`GCP_ZONE`, and `VM_NAME` — override them consistently.

Keyless BigQuery auth
---------------------

The sweep authenticates to BigQuery **without a service-account JSON key**. The
VM is created with a service account attached (`SA_EMAIL`, default
`pankaj-singh@astronomer-dag-authoring.iam.gserviceaccount.com`) and the
`bigquery` OAuth scope; dbt in the kind pods then uses Application Default
Credentials off the GCE metadata server. No key is uploaded to instance
metadata, written to disk, or baked into the image.

What this needs (one-time, per service account):

* The SA exists in the project with least-privilege BigQuery roles — Job User
  on the project and Data Viewer on the benchmark dataset (`release_17`):

  ```
  gcloud iam service-accounts create cosmos-benchmark-bq \
    --project=astronomer-dag-authoring --display-name="cosmos benchmark BQ"
  gcloud projects add-iam-policy-binding astronomer-dag-authoring \
    --member="serviceAccount:cosmos-benchmark-bq@astronomer-dag-authoring.iam.gserviceaccount.com" \
    --role=roles/bigquery.jobUser
  bq add-iam-policy-binding ... --role=roles/bigquery.dataViewer release_17
  ```

  (The default `SA_EMAIL` above reuses an existing SA; point `SA_EMAIL` at a
  dedicated one like `cosmos-benchmark-bq@...` once it's provisioned.)
* Whoever runs `provision.sh` has `iam.serviceAccounts.actAs` on that SA.

Files in this directory:

* `provision.sh` — laptop-side: creates the VM (with a service account
  attached for keyless BigQuery auth — no JSON key uploaded), kicks off the
  sweep via startup script.
* `bootstrap.sh` — runs on the VM (root, as the startup script's payload):
  installs Docker / kind / kubectl / helm, then hands off to `run-sweep.sh`.
* `run-sweep.sh` — on-VM driver: calls the existing `setup.sh` once, then
  loops `(cosmos, threads)`, helm-upgrading the chart between Cosmos
  versions. Output goes to `/opt/cosmos-bench/results/sweep-<ts>.csv|.md`.
* `monitor.sh`, `fetch-results.sh`, `teardown.sh` — laptop-side helpers.
