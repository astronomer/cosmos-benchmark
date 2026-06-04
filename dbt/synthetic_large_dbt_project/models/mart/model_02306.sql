{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01825') }},
        {{ ref('model_01599') }},
        {{ ref('model_01726') }}
)
select id, 'model_02306' as name from sources
