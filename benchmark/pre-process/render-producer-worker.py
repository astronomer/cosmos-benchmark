#!/usr/bin/env python3
"""Render a producer-worker Deployment by mutating the chart-rendered consumer Deployment.

This avoids hard-coding ServiceAccount / ConfigMap / Secret names that the official
Apache Airflow Helm chart sets up for its default workers; we inherit them and only
override the queue, labels, replicas, and resources.

Reads `kubectl get deployment airflow-worker -n airflow -o json` from stdin and
writes a producer-worker Deployment JSON manifest to stdout (kubectl accepts JSON).

Tunable via env vars:
  PRODUCER_REPLICAS  default 1
  PRODUCER_CPU       default "1"
  PRODUCER_MEM       default "2Gi"
  PRODUCER_QUEUE     default "producer"
"""
import json
import os
import sys


def main() -> int:
    src = json.load(sys.stdin)

    replicas = int(os.environ.get("PRODUCER_REPLICAS", "1"))
    cpu = os.environ.get("PRODUCER_CPU", "1")
    mem = os.environ.get("PRODUCER_MEM", "2Gi")
    queue = os.environ.get("PRODUCER_QUEUE", "producer")

    for k in ("uid", "resourceVersion", "creationTimestamp", "generation", "managedFields"):
        src["metadata"].pop(k, None)
    src["metadata"].pop("annotations", None)
    src.pop("status", None)

    src["metadata"]["name"] = "airflow-producer-worker"
    labels = src["metadata"].setdefault("labels", {})
    labels["component"] = "producer-worker"
    labels["cosmos-role"] = "producer"

    spec = src["spec"]
    spec["replicas"] = replicas

    # Producer pool is intentionally a singleton with hefty per-pod resources.
    # On a single-node kind cluster, RollingUpdate (the chart default) tries to
    # keep the old pod running while starting the new one, which doesn't fit.
    # Recreate kills the old before scheduling the new — fine here because the
    # producer is offline anyway during a rollout.
    spec["strategy"] = {"type": "Recreate"}

    # Keep the chart's selector keys (release, tier, etc.) and only swap the
    # component so this Deployment matches its own producer pods, not the
    # consumer pool's. Both pod templates still share the other labels but that
    # is fine — selectors only need to be a subset of pod template labels.
    selector_labels = spec["selector"].setdefault("matchLabels", {})
    selector_labels["component"] = "producer-worker"

    pod_meta = spec["template"]["metadata"]
    pod_labels = pod_meta.setdefault("labels", {})
    pod_labels["component"] = "producer-worker"
    pod_labels["cosmos-role"] = "producer"
    pod_meta.pop("creationTimestamp", None)

    pod_spec = spec["template"]["spec"]
    containers = pod_spec["containers"]
    worker = next((c for c in containers if c["name"] == "worker"), containers[0])
    worker["args"] = ["bash", "-c", f"exec airflow celery worker -q {queue}"]
    worker["resources"] = {
        "requests": {"cpu": cpu, "memory": mem},
        "limits": {"cpu": cpu, "memory": mem},
    }

    json.dump(src, sys.stdout, indent=2)
    sys.stdout.write("\n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
