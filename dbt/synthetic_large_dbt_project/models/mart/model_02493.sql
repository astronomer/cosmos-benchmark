{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01622') }},
        {{ ref('model_01572') }},
        {{ ref('model_02128') }}
)
select id, 'model_02493' as name from sources
