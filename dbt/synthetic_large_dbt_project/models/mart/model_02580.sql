{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01934') }},
        {{ ref('model_01916') }},
        {{ ref('model_02224') }}
)
select id, 'model_02580' as name from sources
