{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01606') }},
        {{ ref('model_01800') }}
)
select id, 'model_02475' as name from sources
