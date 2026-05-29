{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00536') }},
        {{ ref('model_00317') }},
        {{ ref('model_00335') }}
)
select id, 'model_01198' as name from sources
