{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02120') }},
        {{ ref('model_01730') }}
)
select id, 'model_02712' as name from sources
