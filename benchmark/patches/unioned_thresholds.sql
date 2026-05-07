{#
/* Copyright 2022 Google LLC
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    https://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. */
#}
{#
  cosmos-benchmark patch:
  Upstream uses `adapter.get_relation(...)` to look up the threshold seeds at
  runtime, which leaves dbt with no edge between the seed task and this view.
  Under concurrent execution (high `threads`, or LOCAL mode where each model
  is its own task) the seed reload and the view recreation can race, causing
  intermittent "Table release_17.thresholds was not found" failures.
  Replacing the runtime lookup with `ref(name)` registers the dependency in
  dbt's graph so the seed always runs before this model.
#}
-- depends_on: {{ ref('thresholds') }}
{# dbt's static dependency analysis can't see ref() calls inside a {% for %}
   loop ("ref() is placed within a conditional block"), so we surface the
   dependency explicitly via the depends_on hint above. Currently only the
   `thresholds` seed matches the `name[:10] == 'thresholds'` filter; if more
   `thresholds*` seeds are added upstream, list each here so dbt's scheduler
   waits for them. #}
{{ config(
    materialized='view'
) -}}
{%- set models_dict = fhir_dbt_utils.get_dbt_objects('seed') -%}
{%- set threshold_relations = [] -%}
{%- for name, path in models_dict.items()
  if name[:10] == 'thresholds'
-%}
  {%- do threshold_relations.append(ref(name)) %}
{%- endfor -%}
{{ dbt_utils.union_relations(
    relations = threshold_relations,
    source_column_name = "thresholds_source",
    column_override = {
      "metric_name": "STRING",
      "threshold_low": fhir_dbt_utils.type_double(),
      "threshold_high": fhir_dbt_utils.type_double(),
      "time_grain": "STRING",
      "dimension": "STRING",
      "validation_feature": "STRING",
      "severity": "STRING"
    }
) }}
