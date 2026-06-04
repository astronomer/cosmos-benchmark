{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01415') }},
        {{ ref('model_00787') }},
        {{ ref('model_00962') }}
)
select id, 'model_01643' as name from sources
