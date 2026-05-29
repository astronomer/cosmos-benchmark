{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01758') }},
        {{ ref('model_01750') }}
)
select id, 'model_02891' as name from sources
