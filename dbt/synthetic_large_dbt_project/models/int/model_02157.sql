{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00796') }},
        {{ ref('model_00825') }},
        {{ ref('model_01113') }}
)
select id, 'model_02157' as name from sources
