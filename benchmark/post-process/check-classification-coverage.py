#!/usr/bin/env python3
"""Dump unique cmdlines per (role, classification) from a monitor-pod-procs CSV.

Use this after a run to spot any cmdline that landed in a generic bucket
(`other` / `airflow_other`) and probably deserves its own dedicated
classification in `inside-pod-procs.py`.

Usage:
  check-classification-coverage.py <csv_path>
"""
from __future__ import annotations

import csv
import sys
from collections import defaultdict


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: check-classification-coverage.py <csv_path>", file=sys.stderr)
        return 2
    path = sys.argv[1]

    # (role, classification) -> {cmdline: sample_count}
    bucket: dict[tuple[str, str], dict[str, int]] = defaultdict(lambda: defaultdict(int))

    with open(path, newline="") as f:
        reader = csv.DictReader(f)
        for row in reader:
            key = (row.get("role") or "unknown", row["classification"])
            bucket[key][row["cmdline"]] += 1

    # Sort: generic buckets first so the eyes catch them.
    bucket_sort_priority = {
        "other": 0,
        "airflow_other": 1,
    }

    def sort_key(item: tuple[tuple[str, str], dict[str, int]]):
        (role, cls), _ = item
        return (bucket_sort_priority.get(cls, 9), role, cls)

    for (role, cls), cmds in sorted(bucket.items(), key=sort_key):
        print(f"--- role={role}  classification={cls}  ({len(cmds)} unique cmdlines, {sum(cmds.values())} samples) ---")
        for cmd, count in sorted(cmds.items(), key=lambda x: -x[1])[:20]:
            print(f"  [{count:>5} samples]  {cmd}")
        print()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
