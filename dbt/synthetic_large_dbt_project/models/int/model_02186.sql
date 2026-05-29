{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00812') }},
        {{ ref('model_01325') }}
)
select id, 'model_02186' as name from sources
