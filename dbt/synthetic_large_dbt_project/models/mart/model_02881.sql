{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02179') }},
        {{ ref('model_01706') }}
)
select id, 'model_02881' as name from sources
