{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00230') }},
        {{ ref('model_00648') }}
)
select id, 'model_00935' as name from sources
