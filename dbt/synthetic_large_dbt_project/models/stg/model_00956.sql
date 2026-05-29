{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00108') }},
        {{ ref('model_00296') }},
        {{ ref('model_00702') }}
)
select id, 'model_00956' as name from sources
