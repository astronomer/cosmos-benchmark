{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00457') }},
        {{ ref('model_00323') }}
)
select id, 'model_00909' as name from sources
