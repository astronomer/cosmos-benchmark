{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00679') }},
        {{ ref('model_00539') }},
        {{ ref('model_00044') }}
)
select id, 'model_01131' as name from sources
