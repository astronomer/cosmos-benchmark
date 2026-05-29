"""Generate a synthetic dbt project for parse-time benchmarks.

Emits ~3000 model SQL files spread across four tagged layers, with refs
forming a chained DAG so graph-operator selects (e.g. ``+model_X+``) and
tag intersections have non-trivial work to do during ``select_nodes()``.

Usage:
    cd <synthetic_large_dbt_project dir>
    python scripts/generate_project.py [--n-models 3000]
"""

from __future__ import annotations

import argparse
import random
from pathlib import Path

LAYERS = ["raw", "stg", "int", "mart"]  # 4 layers
TAGS_PER_LAYER = {
    "raw": ["raw", "source_data"],
    "stg": ["stg", "transform"],
    "int": ["int", "transform"],
    "mart": ["mart", "reporting"],
}
DOMAINS = ["sales", "finance", "ops", "marketing", "product"]
CRITICALITY = ["critical", "standard", "deprecated"]


def assign_layer(idx: int, total: int) -> str:
    """Spread models across layers (~25% each)."""
    chunk = total // len(LAYERS)
    return LAYERS[min(idx // chunk, len(LAYERS) - 1)]


def model_filename(idx: int) -> str:
    return f"model_{idx:05d}.sql"


def write_dbt_project(root: Path) -> None:
    (root / "dbt_project.yml").write_text(
        """
name: 'synthetic_large_dbt_project'
version: '1.0.0'
config-version: 2

profile: 'synthetic_large_dbt_project'

model-paths: ["models"]
seed-paths: ["seeds"]

target-path: "target"
clean-targets:
  - "target"
  - "dbt_packages"

models:
  synthetic_large_dbt_project:
    raw:
      +materialized: view
    stg:
      +materialized: view
    int:
      +materialized: view
    mart:
      +materialized: table
""".lstrip()
    )

    (root / "profiles.yml").write_text(
        """
synthetic_large_dbt_project:
  target: dev
  outputs:
    dev:
      type: postgres
      host: "{{ env_var('POSTGRES_HOST', 'db') }}"
      user: "{{ env_var('POSTGRES_USER', 'postgres') }}"
      password: "{{ env_var('POSTGRES_PASSWORD', 'password') }}"
      port: "{{ env_var('POSTGRES_PORT', '5432') | int }}"
      dbname: "{{ env_var('POSTGRES_DB', 'postgres') }}"
      schema: "{{ env_var('POSTGRES_SCHEMA', 'public') }}"
      threads: 4
""".lstrip()
    )


def write_seed(root: Path) -> None:
    seed_dir = root / "seeds"
    seed_dir.mkdir(exist_ok=True)
    (seed_dir / "seed_dim.csv").write_text("id,name\n1,foo\n2,bar\n3,baz\n")


def write_models(root: Path, n_models: int, rng: random.Random) -> dict[str, list[str]]:
    """Emit n_models .sql files + schema.yml entries with tags + refs.

    Returns the per-layer tag map (used for schema.yml). Refs are chained:
    each model in layer N refs 1-3 random models in layer N-1 (raw refs the seed).
    """
    models_dir = root / "models"
    models_dir.mkdir(exist_ok=True)

    layer_indices: dict[str, list[int]] = {layer: [] for layer in LAYERS}
    model_meta: list[tuple[int, str, list[str], list[str]]] = []  # (idx, layer, refs, tags)

    for idx in range(n_models):
        layer = assign_layer(idx, n_models)
        layer_indices[layer].append(idx)

        # tags: layer + domain + criticality + maybe extra
        tags = list(TAGS_PER_LAYER[layer])
        tags.append(f"domain_{rng.choice(DOMAINS)}")
        tags.append(rng.choice(CRITICALITY))
        if rng.random() < 0.1:
            tags.append("flaky")
        if rng.random() < 0.05:
            tags.append("expensive")

        # refs: pick from previous-layer models if any
        prev_layer_idx = LAYERS.index(layer) - 1
        refs: list[str] = []
        if prev_layer_idx >= 0:
            prev_layer = LAYERS[prev_layer_idx]
            candidates = layer_indices[prev_layer]
            if candidates:
                k = rng.randint(1, min(3, len(candidates)))
                refs = [model_filename(i).replace(".sql", "") for i in rng.sample(candidates, k)]
        elif layer == "raw":
            # raw refs the seed
            refs = ["seed_dim"]

        layer_dir = models_dir / layer
        layer_dir.mkdir(exist_ok=True)
        model_name = model_filename(idx).replace(".sql", "")

        # SQL body: SELECT from refs (or seed) with trivial joins to make
        # nodes have real upstream deps in the manifest. We don't run
        # these, only parse.
        if refs:
            ref_calls = ",\n        ".join(f"{{{{ ref('{r}') }}}}" for r in refs)
            sql = (
                "{{ config(materialized='view') }}\n\n"
                "with sources as (\n"
                "    select 1 as id\n"
                "    from " + ref_calls + "\n"
                ")\n"
                f"select id, '{model_name}' as name from sources\n"
            )
        else:
            sql = (
                "{{ config(materialized='view') }}\n\n"
                f"select 1 as id, '{model_name}' as name\n"
            )
        (layer_dir / f"{model_name}.sql").write_text(sql)

        model_meta.append((idx, layer, refs, tags))

    # one schema.yml per layer
    for layer in LAYERS:
        entries = [m for m in model_meta if m[1] == layer]
        lines = ["version: 2", "", "models:"]
        for idx, _, _, tags in entries:
            name = model_filename(idx).replace(".sql", "")
            tag_yaml = "[" + ", ".join(tags) + "]"
            lines.append(f"  - name: {name}")
            lines.append(f"    config:")
            lines.append(f"      tags: {tag_yaml}")
        (models_dir / layer / "schema.yml").write_text("\n".join(lines) + "\n")

    return {layer: [model_filename(i).replace(".sql", "") for i in layer_indices[layer]] for layer in LAYERS}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--n-models", type=int, default=3000)
    parser.add_argument(
        "--rng-seed",
        type=int,
        default=42,
        help="Seed for Python's random.Random (unrelated to dbt seeds).",
    )
    args = parser.parse_args()

    root = Path(__file__).resolve().parent.parent
    rng = random.Random(args.rng_seed)
    write_dbt_project(root)
    write_seed(root)
    summary = write_models(root, args.n_models, rng)
    for layer, names in summary.items():
        print(f"  {layer}: {len(names)} models")
    print(f"Project root: {root}")


if __name__ == "__main__":
    main()
