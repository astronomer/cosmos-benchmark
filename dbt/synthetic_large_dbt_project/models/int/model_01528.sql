{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01260') }},
        {{ ref('model_00851') }},
        {{ ref('model_00907') }}
)
select id, 'model_01528' as name from sources
