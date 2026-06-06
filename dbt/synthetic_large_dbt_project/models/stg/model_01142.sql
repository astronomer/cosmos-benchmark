{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00337') }},
        {{ ref('model_00459') }},
        {{ ref('model_00555') }}
)
select id, 'model_01142' as name from sources
