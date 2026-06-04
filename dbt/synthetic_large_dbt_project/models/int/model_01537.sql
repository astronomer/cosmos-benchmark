{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01316') }},
        {{ ref('model_01061') }},
        {{ ref('model_01488') }}
)
select id, 'model_01537' as name from sources
