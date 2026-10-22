"""Store and restore cost of XCom backup layouts in the Airflow task store, on a real Airflow task.

Usage: python bench_task_store_layouts.py <layout> <nodes>
layout: none | grouped | rows20 | rows8kb | perkey
"""

import base64
import json
import random
import string
import sys
import time
import zlib
from datetime import datetime, timedelta

from airflow.sdk import DAG, task
from airflow.utils import timezone

LAYOUT = sys.argv[1]
NODES = int(sys.argv[2])
KEY = "cosmos_xcom_backup"
WARNING_LIMIT = 65535
results = {}


def encode(obj):
    return base64.b64encode(zlib.compress(json.dumps(obj, default=str).encode("utf-8"))).decode("utf-8")


def decode(blob):
    return json.loads(zlib.decompress(base64.b64decode(blob.encode("utf-8"))).decode("utf-8"))


def build_pushes(nodes):
    random.seed(nodes)
    pushes = []
    for i in range(nodes):
        sql = "select " + " ".join("".join(random.choices(string.ascii_lowercase, k=8)) for _ in range(100)) + " from t"
        pushes.append((f"model__p__m{i}_status", {"status": "success", "outlet_uris": []}))
        pushes.append((f"model__p__m{i}_dbt_event", {"status": "success", "start_time": "09:16:52", "finish_time": "09:16:53", "msg": "OK"}))
        pushes.append((f"model__p__m{i}_compiled_sql", sql))
        pushes.append((f"model__p__m{i}_tests_status", {"status": "pass", "passed_count": 2, "failed_count": 0, "total_count": 2, "failed_tests": []}))
    return pushes


class Layout:
    def __init__(self, store):
        self.store = store
        self.bytes_written = 0
        self.writes = 0
        self.over_limit = 0

    def write(self, key, blob):
        self.store.set(key, blob)
        self.writes += 1
        self.bytes_written += len(blob)
        if len(json.dumps(blob)) > WARNING_LIMIT:
            self.over_limit += 1

    def read_sequence(self, prefix):
        entries, reads = {}, 0
        while True:
            blob = self.store.get(f"{prefix}_{reads}")
            reads += 1
            if blob is None:
                return entries, reads
            entries.update(decode(blob))

    def delete_sequence(self, prefix, count):
        for index in range(count):
            self.store.delete(f"{prefix}_{index}")


class NoBackup(Layout):
    def push(self, key, value):
        pass

    def restore(self):
        return {}, 0

    def delete(self):
        pass


class Grouped(Layout):
    def __init__(self, store):
        super().__init__(store)
        self.buffer = {}

    def push(self, key, value):
        self.buffer[key] = value
        self.write(KEY, encode(self.buffer))

    def restore(self):
        blob = self.store.get(KEY)
        return (decode(blob) if blob else {}), 1

    def delete(self):
        self.store.delete(KEY)


class Rows(Layout):
    def __init__(self, store, max_entries=None, max_bytes=None):
        super().__init__(store)
        self.max_entries, self.max_bytes = max_entries, max_bytes
        self.open_row, self.index = {}, 0

    def push(self, key, value):
        self.open_row[key] = value
        blob = encode(self.open_row)
        self.write(f"{KEY}_{self.index}", blob)
        full_by_count = self.max_entries is not None and len(self.open_row) >= self.max_entries
        full_by_size = self.max_bytes is not None and len(blob) >= self.max_bytes
        if full_by_count or full_by_size:
            self.index += 1
            self.open_row = {}

    def restore(self):
        return self.read_sequence(KEY)

    def delete(self):
        self.delete_sequence(KEY, self.index + 1)


class PerKey(Layout):
    def __init__(self, store):
        super().__init__(store)
        self.sequence = 0

    def push(self, key, value):
        self.write(f"{KEY}_{self.sequence}", encode({key: value}))
        self.sequence += 1

    def restore(self):
        return self.read_sequence(KEY)

    def delete(self):
        self.delete_sequence(KEY, self.sequence)


class VariableBackup(Layout):
    """Cosmos 1.15: the whole buffer in one Airflow Variable, rewritten on every push."""

    KEY = "cosmos_xcom_backup_bench_variable"

    def __init__(self, store):
        super().__init__(store)
        from airflow.sdk import Variable

        self.variable = Variable
        self.buffer = {}

    def push(self, key, value):
        self.buffer[key] = value
        blob = encode(self.buffer)
        self.variable.set(self.KEY, blob)
        self.writes += 1
        self.bytes_written += len(blob)

    def restore(self):
        blob = self.variable.get(self.KEY, default=None)
        return (decode(blob) if blob else {}), 1

    def delete(self):
        self.variable.delete(self.KEY)


def make_layout(store):
    if LAYOUT == "none":
        return NoBackup(store)
    if LAYOUT == "variable":
        return VariableBackup(store)
    if LAYOUT == "grouped":
        return Grouped(store)
    if LAYOUT == "rows20":
        return Rows(store, max_entries=20)
    if LAYOUT.startswith("rows") and LAYOUT.endswith("kb"):
        return Rows(store, max_bytes=int(LAYOUT[len("rows"):-len("kb")]) * 1024)
    if LAYOUT == "perkey":
        return PerKey(store)
    raise SystemExit(f"unknown layout {LAYOUT}")


layouts = {}


@task(retries=1, retry_delay=timedelta(seconds=0))
def producer(**context):
    ti = context["ti"]
    store = context["task_state_store"]
    if ti.try_number == 1:
        layout = layouts["first"] = make_layout(store)
        backup_time = 0.0
        started = time.perf_counter()
        for key, value in build_pushes(NODES):
            ti.xcom_push(key=key, value=value)
            backup_started = time.perf_counter()
            layout.push(key, value)
            backup_time += time.perf_counter() - backup_started
        results.update(
            store_total_s=time.perf_counter() - started,
            backup_only_s=backup_time,
            writes=layout.writes,
            bytes_written=layout.bytes_written,
            writes_over_limit=layout.over_limit,
        )
        raise RuntimeError("fail the first attempt")
    layout = make_layout(store)
    first = layouts["first"]
    layout.index = getattr(first, "index", 0)
    layout.sequence = getattr(first, "sequence", 0)
    started = time.perf_counter()
    entries, reads = layout.restore()
    results["restore_read_s"] = time.perf_counter() - started
    started = time.perf_counter()
    for key, value in entries.items():
        ti.xcom_push(key=key, value=value)
    results["restore_repush_s"] = time.perf_counter() - started
    started = time.perf_counter()
    layout.delete()
    results.update(delete_s=time.perf_counter() - started, restored_entries=len(entries), reads=reads)


def serialize(dag):
    from airflow.dag_processing.dagbag import DagBag, sync_bag_to_db
    from airflow.models.dagbundle import DagBundleModel
    from airflow.utils.session import create_session

    with create_session() as session:
        session.merge(DagBundleModel(name="bench_bundle"))
        session.commit()
    dagbag = DagBag(dag_folder=None, collect_dags=False)
    dagbag.bag_dag(dag)
    sync_bag_to_db(dagbag, bundle_name="bench_bundle", bundle_version="1")


with DAG(f"bench_{LAYOUT}_{NODES}", start_date=datetime(2024, 1, 1), schedule=None) as dag:
    producer()

serialize(dag)
dag.test(logical_date=timezone.utcnow())
print("RESULT " + json.dumps({"layout": LAYOUT, "nodes": NODES, **results}))
