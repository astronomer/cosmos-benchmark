{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02112') }},
        {{ ref('model_01982') }},
        {{ ref('model_01737') }}
)
select id, 'model_02449' as name from sources
