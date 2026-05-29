{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00111') }},
        {{ ref('model_00159') }},
        {{ ref('model_00108') }}
)
select id, 'model_00783' as name from sources
