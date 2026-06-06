{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01577') }},
        {{ ref('model_01703') }},
        {{ ref('model_01595') }}
)
select id, 'model_02473' as name from sources
