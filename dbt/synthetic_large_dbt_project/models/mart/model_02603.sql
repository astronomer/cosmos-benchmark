{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01890') }},
        {{ ref('model_02147') }}
)
select id, 'model_02603' as name from sources
