{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02085') }},
        {{ ref('model_02160') }}
)
select id, 'model_02545' as name from sources
