{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00354') }},
        {{ ref('model_00679') }}
)
select id, 'model_00904' as name from sources
