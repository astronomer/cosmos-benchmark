{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00208') }},
        {{ ref('model_00554') }}
)
select id, 'model_00931' as name from sources
