{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00242') }},
        {{ ref('model_00729') }},
        {{ ref('model_00513') }}
)
select id, 'model_01237' as name from sources
