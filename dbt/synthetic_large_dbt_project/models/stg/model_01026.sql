{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00009') }},
        {{ ref('model_00717') }},
        {{ ref('model_00269') }}
)
select id, 'model_01026' as name from sources
