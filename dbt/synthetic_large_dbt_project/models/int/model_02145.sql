{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01050') }},
        {{ ref('model_00999') }},
        {{ ref('model_01086') }}
)
select id, 'model_02145' as name from sources
