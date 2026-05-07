#!/usr/bin/env python3
"""Snapshot per-process resource usage from /proc.

Designed to run inside a worker pod via `kubectl exec ... python3 - < this_file`.
Uses only the Python stdlib so it works in the slim apache/airflow image.

Output: CSV rows (no header) — `ts,classification,pid,rss_kb,cpu_jiffies,cmdline`.
The orchestrator (`monitor-pod-procs.sh`) prepends pod + role and accumulates
into the run-wide CSV.

Classification buckets are matched on the process cmdline:
  - dbt                 — actual dbt executions (the work we care about)
  - airflow_task_run    — airflow's task supervisor wrapping a task instance
  - celery_forkpool     — celery prefork worker slots (4 per pod with concurrency=4)
  - celery_main         — celery's MainProcess
  - airflow_celery      — airflow celery worker entrypoint
  - airflow_serve_logs  — airflow's log-server sidecar process
  - airflow_other       — any other airflow-prefixed process
  - other               — everything else (dumb-init, sampler itself, etc.)
"""
from __future__ import annotations

import os
import time


def classify(cmd: str) -> str:
    # Order matters: more specific patterns first so a generic substring like
    # "airflow celery worker" (which appears inside dumb-init's cmdline) doesn't
    # capture an unrelated process.
    if cmd.startswith("/usr/bin/dumb-init"):
        return "dumb_init"
    if "ForkPoolWorker" in cmd:
        return "celery_forkpool"
    if "MainProcess" in cmd:
        return "celery_main"
    # `airflow worker -- <task-instance-uuid>` is Celery's per-task supervisor
    # process spawned for each task. This is where the actual task code runs
    # (including in-process dbt invocations via dbtRunner). Highest-value
    # bucket for per-task attribution.
    if " worker -- " in cmd or "airflow tasks run" in cmd or "airflow.sdk.execution_time" in cmd:
        return "airflow_task_run"
    if " dbt " in f" {cmd} " or "/dbt " in cmd or cmd.endswith("/dbt"):
        return "dbt"
    if "multiprocessing.resource_tracker" in cmd:
        return "mp_resource_tracker"
    if "inspect ping" in cmd:
        return "celery_inspect_ping"
    if "airflow jobs check" in cmd:
        return "airflow_health_check"
    # Self-noise from the benchmark monitor itself querying the api-server.
    if "airflow dags list-runs" in cmd or "airflow tasks states-for-dag-run" in cmd:
        return "monitor_self"
    if "airflow serve-logs" in cmd:
        return "airflow_serve_logs"
    if "airflow celery worker" in cmd:
        return "airflow_celery"
    if "airflow triggerer" in cmd:
        return "airflow_triggerer"
    if "airflow scheduler" in cmd:
        return "airflow_scheduler"
    if "airflow dag-processor" in cmd:
        return "airflow_dag_processor"
    if "airflow api" in cmd or "airflow api-server" in cmd or "airflow api_server" in cmd:
        return "airflow_api_server"
    if "airflow" in cmd:
        return "airflow_other"
    return "other"


def parse_stat_jiffies(stat_text: str) -> int:
    # /proc/<pid>/stat: comm field is in parens and may contain spaces, so we
    # find the last ')' and split the remainder. After comm, fields are
    # state, ppid, pgrp, ... ; utime is field 14 / stime is field 15
    # (1-indexed in the kernel docs). After dropping pid+comm, that's
    # 0-indexed positions 11 and 12 in the remaining tokens.
    close_paren = stat_text.rindex(")")
    fields = stat_text[close_paren + 2 :].split()
    return int(fields[11]) + int(fields[12])


def main() -> int:
    ts = time.time()
    own_pid = os.getpid()
    for pid_str in os.listdir("/proc"):
        if not pid_str.isdigit():
            continue
        pid = int(pid_str)
        if pid == own_pid:
            # Don't sample ourselves — adds noise (~10 MiB) and confuses totals.
            continue
        try:
            with open(f"/proc/{pid}/cmdline", "rb") as f:
                cmd = f.read().replace(b"\0", b" ").decode("utf-8", "replace").strip()
            if not cmd:
                continue
            # Also filter the bare `python3 -` invocation (us, before argv is
            # exposed) and the parent shell wrapper.
            if cmd in ("python3 -", "python3"):
                continue
            rss = 0
            with open(f"/proc/{pid}/status") as f:
                for line in f:
                    if line.startswith("VmRSS:"):
                        rss = int(line.split()[1])
                        break
            with open(f"/proc/{pid}/stat") as f:
                stat = f.read()
            jiffies = parse_stat_jiffies(stat)
        except (FileNotFoundError, ProcessLookupError, PermissionError, OSError):
            # Process may have exited between listdir and stat read; skip silently.
            continue
        cls = classify(cmd)
        cmd_esc = cmd.replace('"', '""')[:200]
        print(f'{ts},{cls},{pid},{rss},{jiffies},"{cmd_esc}"')
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
