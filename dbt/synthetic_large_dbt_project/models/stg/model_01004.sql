{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00323') }},
        {{ ref('model_00418') }},
        {{ ref('model_00370') }}
)
select id, 'model_01004' as name from sources
