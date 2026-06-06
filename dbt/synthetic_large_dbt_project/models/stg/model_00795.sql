{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00421') }},
        {{ ref('model_00563') }}
)
select id, 'model_00795' as name from sources
