#!/usr/bin/env python3
"""Aggregate the CSV produced by `monitor-pod-procs.sh` into a per-(role, classification) summary.

For each (role, classification) bucket, we report:

  - peak_rss_summed_mib:  max over all sampled timestamps of the SUM of RSS across
                          all matching processes at that timestamp. Captures peak
                          memory pressure attributable to that bucket.
  - cpu_seconds_total:    sum across PIDs of (max_jiffies - min_jiffies) / SC_CLK_TCK.
                          Captures total CPU work attributable to that bucket over
                          the run window.

The `classification` column in the CSV is re-derived from `cmdline` using the
current `inside-pod-procs.classify()` function — that way older CSVs sampled
before classifier changes still aggregate using the latest taxonomy.

Usage: aggregate-pod-procs.py <csv_path>
"""
from __future__ import annotations

import csv
import importlib.util
import os
import sys
from collections import defaultdict


SC_CLK_TCK = 100  # standard on Linux x86_64; could probe via getconf inside the pod.


def _load_classifier():
    """Import classify() from inside-pod-procs.py without making it a package."""
    here = os.path.dirname(os.path.abspath(__file__))
    spec = importlib.util.spec_from_file_location(
        "inside_pod_procs", os.path.join(here, "inside-pod-procs.py")
    )
    mod = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(mod)
    return mod.classify


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: aggregate-pod-procs.py <csv_path>", file=sys.stderr)
        return 2
    path = sys.argv[1]

    classify = _load_classifier()

    # buckets[(role, classification)] -> dict of bookkeeping
    rss_by_ts: dict[tuple[str, str], dict[float, int]] = defaultdict(lambda: defaultdict(int))
    jiffies_by_pid: dict[tuple[str, str], dict[int, list[int]]] = defaultdict(lambda: defaultdict(list))

    sample_count = 0
    with open(path, newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            sample_count += 1
            cls = classify(row["cmdline"])
            key = (row["role"] or "unknown", cls)
            ts = float(row["ts"])
            pid = int(row["pid"])
            rss = int(row["rss_kb"])
            jif = int(row["cpu_jiffies"])
            rss_by_ts[key][ts] += rss
            jiffies_by_pid[key][pid].append(jif)

    if sample_count == 0:
        print(f"No samples found in {path}", file=sys.stderr)
        return 1

    print(f"# Aggregated from {sample_count} process samples in {path}")
    print()
    header = f"{'role':<14}{'classification':<22}{'peak_rss_mib':>14}{'cpu_seconds':>14}"
    print(header)
    print("-" * len(header))

    # Sort by role then by descending CPU
    rows: list[tuple[str, str, float, float]] = []
    for key, ts_map in rss_by_ts.items():
        role, cls = key
        peak_rss_kb = max(ts_map.values()) if ts_map else 0
        peak_rss_mib = peak_rss_kb / 1024.0
        cpu_seconds = sum(
            (max(js) - min(js)) / SC_CLK_TCK
            for js in jiffies_by_pid[key].values()
        )
        rows.append((role, cls, peak_rss_mib, cpu_seconds))

    rows.sort(key=lambda r: (r[0], -r[3]))
    for role, cls, mib, secs in rows:
        print(f"{role:<14}{cls:<22}{mib:>11.1f} MiB{secs:>12.1f}s")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
