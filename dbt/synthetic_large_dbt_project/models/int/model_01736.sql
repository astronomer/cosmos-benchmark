{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00837') }},
        {{ ref('model_01136') }}
)
select id, 'model_01736' as name from sources
