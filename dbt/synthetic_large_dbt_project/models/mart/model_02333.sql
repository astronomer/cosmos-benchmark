{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01907') }},
        {{ ref('model_02242') }}
)
select id, 'model_02333' as name from sources
