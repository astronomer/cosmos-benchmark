# XCom backup layout micro-benchmark

Measures how the Cosmos watcher producer's XCom backup behaves in the Airflow task store (Airflow 3.3+)
and in an Airflow Variable, on a real Airflow task runner, without dbt.

`bench_task_store_layouts.py <layout> <nodes>` runs one DAG with `dag.test()`. A `@task` plays the
producer: for each node it pushes the four XComs the watcher producer pushes per model
(`<model>_status`, `<model>_dbt_event`, `<model>_tests_status` and `<model>_compiled_sql`, the last one
a distinct ~900 byte string of random words so it compresses like real SQL), backing each push up with
the layout under test. It then fails, and its retry restores the backup, re-pushes the entries and
deletes it. So 1000 nodes means 4000 pushes and 4000 entries to restore.

Layouts:

- `none`: no backup, the baseline
- `variable`: the whole buffer in one Airflow Variable, rewritten on every push (Cosmos 1.15)
- `grouped`: the whole buffer in one task store key, rewritten on every push
- `rows20`: rows of 20 entries
- `rows<N>kb`: rows closed once their encoded size reaches N KB (for example `rows8kb`)
- `perkey`: one task store key per push

Each run prints a `RESULT {...}` JSON line with the store time, bytes sent to the supervisor, writes above
Airflow's 64 KB warning threshold, restore reads and times, and delete time.

```
uv venv venv-af34 --python 3.12
uv pip install --prerelease=allow --python venv-af34/bin/python "apache-airflow==3.4.0b2"
export AIRFLOW_HOME=$PWD/airflow_home && venv-af34/bin/airflow db migrate
for nodes in 100 500 1000; do
  for layout in none variable grouped rows20 rows8kb perkey; do
    venv-af34/bin/python bench_task_store_layouts.py "$layout" "$nodes" | grep ^RESULT | sed 's/^RESULT //' >> results.jsonl
  done
done
python3 summarise_layouts.py results.jsonl   # mean +/- stdev per layout and size
```
