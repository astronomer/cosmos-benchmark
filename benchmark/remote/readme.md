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
* VM `n2-standard-12` (12 vCPU / 48 GiB, ~$0.58/hr, mirrors an Apple M4 Pro)
* Sweep `cosmos ∈ {1.13.1, 1.14.2}` × `threads ∈ {4, 8, 16}` × `5 reps`
  → ~3 hrs of VM time (≈ $1.75)

Override via env vars on `provision.sh` (e.g. `MACHINE_TYPE=n2-standard-16
COSMOS_VERSIONS="1.13.1 1.14.0 1.14.2" ./provision.sh`). `monitor.sh`,
`fetch-results.sh`, and `teardown.sh` all read the same `GCP_PROJECT`,
`GCP_ZONE`, and `VM_NAME` — override them consistently.

Files in this directory:

* `provision.sh` — laptop-side: creates the VM, uploads `key.json` via
  instance metadata, kicks off the sweep via startup script.
* `bootstrap.sh` — runs on the VM (root, as the startup script's payload):
  installs Docker / kind / kubectl / helm, then hands off to `run-sweep.sh`.
* `run-sweep.sh` — on-VM driver: calls the existing `setup.sh` once, then
  loops `(cosmos, threads)`, helm-upgrading the chart between Cosmos
  versions. Output goes to `/opt/cosmos-bench/results/sweep-<ts>.csv|.md`.
* `monitor.sh`, `fetch-results.sh`, `teardown.sh` — laptop-side helpers.
