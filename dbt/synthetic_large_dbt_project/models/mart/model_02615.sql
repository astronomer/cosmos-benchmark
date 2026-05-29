{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02147') }},
        {{ ref('model_02086') }}
)
select id, 'model_02615' as name from sources
