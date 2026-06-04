{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01306') }},
        {{ ref('model_01329') }},
        {{ ref('model_01050') }}
)
select id, 'model_02057' as name from sources
