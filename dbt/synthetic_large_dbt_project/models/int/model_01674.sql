{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00843') }},
        {{ ref('model_01044') }},
        {{ ref('model_01411') }}
)
select id, 'model_01674' as name from sources
