{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01907') }},
        {{ ref('model_02122') }}
)
select id, 'model_02981' as name from sources
