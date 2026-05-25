"""
Build-time graph cache for Cosmos.

The dbt project is baked into the image. The image is immutable. Therefore:
  * dbt_ls.json is correct iff the image is correct.
  * The parsed dbt graph is correct iff the image is correct.
  * The folder-version hash is "image-build" — invariant across pods.

We exploit this by:
  1. Pre-parsing dbt_ls.json once at image-build time and writing the parsed
     `nodes` dict to a sibling pickle file (e.g. dbt_ls.json.pkl).
  2. Monkey-patching DbtGraph.load_via_dbt_ls_file to unpickle that file
     instead of re-parsing JSON. No content-hash check — pickle existence
     is the cache key.
  3. Monkey-patching cosmos.cache._create_folder_version_hash (and its
     re-exports) to return a static string, since the project never
     changes within an image and the only consumer that matters
     (DAG-docs metadata) doesn't need a real fingerprint.

Usage:
    import dbt_graph_cache_poc
    dbt_graph_cache_poc.install()
"""

import logging
import os
import pickle
from pathlib import Path

logger = logging.getLogger("dbt_graph_cache_poc")

STATIC_HASH = "image-build"


def install() -> None:
    """Apply the two monkey-patches. Idempotent.

    Skipped entirely when COSMOS_GRAPH_CACHE_POC_DISABLE=1 is set, so
    benchmark scripts can run with/without the POC against the same image.
    """
    if os.environ.get("COSMOS_GRAPH_CACHE_POC_DISABLE") == "1":
        logger.info("dbt_graph_cache_poc disabled via COSMOS_GRAPH_CACHE_POC_DISABLE=1")
        return

    from cosmos.constants import LoadMode
    from cosmos.dbt.graph import DbtGraph
    import cosmos.cache
    import cosmos.versioning

    if getattr(DbtGraph, "_graph_cache_patched", False):
        return

    # 1) DbtGraph.load_via_dbt_ls_file → unpickle the sibling .pkl if present.
    _original_load = DbtGraph.load_via_dbt_ls_file

    def patched_load(self) -> None:
        src = Path(self.render_config.dbt_ls_path)
        pkl = src.with_suffix(src.suffix + ".pkl")
        if pkl.exists():
            with pkl.open("rb") as fp:
                nodes = pickle.load(fp)
            self.nodes = nodes
            self.filtered_nodes = nodes
            self.load_method = LoadMode.DBT_LS_FILE
            logger.info("Graph cache HIT: %d nodes from %s", len(nodes), pkl)
            return
        logger.info("Graph cache MISS: parsing %s then pickling to %s", src, pkl)
        _original_load(self)
        with pkl.open("wb") as fp:
            pickle.dump(self.nodes, fp, protocol=pickle.HIGHEST_PROTOCOL)

    DbtGraph.load_via_dbt_ls_file = patched_load

    # 2) Skip the folder hash. Patch all import bindings.
    def static_hash(dir_path):  # noqa: ARG001
        return STATIC_HASH

    cosmos.versioning._create_folder_version_hash = static_hash
    cosmos.cache._create_folder_version_hash = static_hash
    # cosmos.converter binds the function locally via `from ... import _create_folder_version_hash`
    import cosmos.converter
    cosmos.converter._create_folder_version_hash = static_hash

    DbtGraph._graph_cache_patched = True
    logger.info("dbt_graph_cache_poc installed: pickle-only graph load + static folder hash")
