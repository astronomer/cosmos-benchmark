import json
import statistics
import sys
from collections import defaultdict

rows = [json.loads(line) for line in open(sys.argv[1]) if line.strip()]
groups = defaultdict(list)
for row in rows:
    groups[(row["nodes"], row["layout"])].append(row)
order = {"none": 0, "variable": 0.5, "grouped": 1, "rows20": 2, "rows8kb": 3, "rows16kb": 4, "rows32kb": 5, "rows48kb": 6, "rows64kb": 7, "perkey": 8}


def stat(samples, key, digits=1):
    values = [sample.get(key, 0) for sample in samples]
    mean = statistics.mean(values)
    spread = statistics.stdev(values) if len(values) > 1 else 0.0
    return f"{mean:.{digits}f} +/- {spread:.{digits}f}"


print("| nodes | layout | n | backup only s | store total s | MB sent | writes over 64 KB | restore reads | restore read s | re-push s | delete s |")
print("|---|---|---|---|---|---|---|---|---|---|---|")
for (nodes, layout), samples in sorted(groups.items(), key=lambda item: (item[0][0], order.get(item[0][1], 9))):
    mb = [sample["bytes_written"] / 1e6 for sample in samples]
    print(
        f"| {nodes} | {layout} | {len(samples)} | {stat(samples, 'backup_only_s')} | {stat(samples, 'store_total_s')} | "
        f"{statistics.mean(mb):.1f} | {int(statistics.mean(sample['writes_over_limit'] for sample in samples))} | "
        f"{int(statistics.mean(sample.get('reads', 0) for sample in samples))} | {stat(samples, 'restore_read_s', 2)} | "
        f"{stat(samples, 'restore_repush_s')} | {stat(samples, 'delete_s', 2)} |"
    )
