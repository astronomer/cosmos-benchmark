#!/usr/bin/env python3
"""Summarise per-pool metrics CSV into a per-config (mean ± stdev) markdown table.

Reads the CSV produced by `report-dag-run-pool-metrics.sh` (one row per rep,
identified by the BENCH_LABEL column), groups rows by label, and emits a
markdown table with mean ± sample-standard-deviation (n-1 denominator) for
each metric.

Usage:
  ./summarise-metrics.py /path/to/results.csv > results.md
  ./summarise-metrics.py /path/to/results.csv \\
    --label-order "LOCAL,WATCHER threads=4,WATCHER threads=8,WATCHER threads=12,WATCHER threads=16"

Designed for stdlib only — no pandas dependency.
"""
import argparse
import csv
import statistics
from collections import OrderedDict


# (csv_column, table_row_label, decimal_places). Memory columns are converted
# from raw bytes to MiB before averaging so cells display in human units.
METRIC_COLUMNS = [
    ("duration_s",              "Wall time (s)",             0),
    # `__tasks_result__` is a synthetic marker — rendered by format_result_cell()
    # below since success/total counts aren't a numeric mean ± stdev.
    ("__tasks_result__",        "Tasks succeeded / total",   None),
    ("producer_duration_s",     "Producer task duration (s)", 0),
    ("tail_s",                  "Tail (DAG − producer, s)",   0),
    ("producer_max_cpu_cores",  "Producer max CPU (cores)",  2),
    ("producer_total_cpu_s",    "Producer total CPU (s)",    0),
    ("producer_peak_mem_bytes", "Producer peak mem (MiB)",   0),
    ("consumer_max_cpu_cores",  "Consumer max CPU (cores)",  2),
    ("consumer_total_cpu_s",    "Consumer total CPU (s)",    0),
    ("consumer_peak_mem_bytes", "Consumer peak mem (MiB)",   0),
    ("total_max_cpu_cores",     "Total max CPU (cores)",     2),
    ("total_total_cpu_s",       "Total CPU (s)",             0),
    ("total_peak_mem_bytes",    "Total peak mem (MiB)",      0),
]


def to_float(value):
    try:
        return float(value)
    except (TypeError, ValueError):
        return None


def format_result_cell(rows):
    """Render tasks_success/tasks_total across N reps.

    All clean: "188/188 (5/5 ✅)"
    Mixed:     "min=187/188 (4/5 ✅)" — lowest-success rep + clean-rep count
    """
    pairs = []
    for r in rows:
        s = to_float(r.get("tasks_success"))
        t = to_float(r.get("tasks_total"))
        if s is not None and t is not None:
            pairs.append((int(s), int(t)))
    if not pairs:
        return "—"
    clean = sum(1 for s, t in pairs if s == t)
    n = len(pairs)
    if clean == n:
        s, t = pairs[0]
        return f"{s}/{t} ({clean}/{n} ✅)"
    worst = min(pairs, key=lambda p: p[0])
    return f"min={worst[0]}/{worst[1]} ({clean}/{n} ✅)"


def main():
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument(
        "csv_path",
        help="Path to the CSV produced by report-dag-run-pool-metrics.sh",
    )
    parser.add_argument(
        "--label-order",
        help=(
            "Comma-separated config labels in column order "
            "(e.g. 'LOCAL,WATCHER threads=4,WATCHER threads=8'). "
            "Labels present in the CSV but not in this list are appended at "
            "the end so no data is silently dropped."
        ),
    )
    args = parser.parse_args()

    rows_by_label = OrderedDict()
    with open(args.csv_path, newline="") as f:
        for row in csv.DictReader(f):
            rows_by_label.setdefault(row["label"], []).append(row)

    if args.label_order:
        ordered = [l.strip() for l in args.label_order.split(",")]
        for l in rows_by_label:
            if l not in ordered:
                ordered.append(l)
    else:
        ordered = list(rows_by_label.keys())

    print("| Metric | " + " | ".join(ordered) + " |")
    print("|" + " --- |" * (1 + len(ordered)))

    for col, display_name, ndigits in METRIC_COLUMNS:
        cells = [display_name]
        if col == "__tasks_result__":
            for label in ordered:
                cells.append(format_result_cell(rows_by_label.get(label, [])))
            print("| " + " | ".join(cells) + " |")
            continue
        for label in ordered:
            values = [to_float(r.get(col, "")) for r in rows_by_label.get(label, [])]
            values = [v for v in values if v is not None]
            if not values:
                cells.append("—")
                continue
            if col.endswith("_peak_mem_bytes"):
                values = [v / 1048576 for v in values]
            mean = statistics.mean(values)
            stdev = statistics.stdev(values) if len(values) >= 2 else 0.0
            cells.append(f"{mean:.{ndigits}f} ± {stdev:.{ndigits}f} (n={len(values)})")
        print("| " + " | ".join(cells) + " |")


if __name__ == "__main__":
    main()
