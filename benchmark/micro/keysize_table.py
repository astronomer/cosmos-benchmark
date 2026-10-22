import json
import statistics
import sys
from collections import defaultdict

rows = [json.loads(line) for line in open(sys.argv[1]) if line.strip()]
sizes = ["rows8kb", "rows16kb", "rows32kb", "rows48kb", "rows63kb"]
labels = {"rows8kb": "8 KB", "rows16kb": "16 KB", "rows32kb": "32 KB", "rows48kb": "48 KB", "rows63kb": "63 KB"}
groups = defaultdict(list)
for row in rows:
    if row["layout"] in sizes:
        groups[(row["nodes"], row["layout"])].append(row)


def stat(samples, key, digits=1):
    values = [sample.get(key, 0) for sample in samples]
    mean = statistics.mean(values)
    spread = statistics.stdev(values) if len(values) > 1 else 0.0
    return f"{mean:.{digits}f} +/- {spread:.{digits}f} s" if digits else f"{mean:.0f}"


print("| nodes | backup writes | key size | n | backup write time | restore read | delete | backup total | scenario total | bytes sent | keys written (reads on retry) |")
print("|---|---|---|---|---|---|---|---|---|---|---|")
for nodes in (100, 500, 1000):
    for size in sizes:
        samples = groups.get((nodes, size))
        if not samples:
            continue
        for sample in samples:
            sample["backup_total_s"] = sample["backup_only_s"] + sample.get("restore_read_s", 0) + sample.get("delete_s", 0)
            sample["scenario_total_s"] = sample["store_total_s"] + sample.get("restore_read_s", 0) + sample.get("restore_repush_s", 0) + sample.get("delete_s", 0)
        print(
            f"| {nodes} | {samples[0]['writes']} | {labels[size]} | {len(samples)} | {stat(samples, 'backup_only_s')} | "
            f"{stat(samples, 'restore_read_s', 2)} | {stat(samples, 'delete_s', 2)} | {stat(samples, 'backup_total_s')} | {stat(samples, 'scenario_total_s')} | "
            f"{statistics.mean(s['bytes_written'] for s in samples) / 1e6:.1f} MB | {int(statistics.mean(s['reads'] for s in samples)) - 1} |"
        )
