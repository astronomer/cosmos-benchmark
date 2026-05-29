{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02224') }},
        {{ ref('model_01997') }}
)
select id, 'model_02470' as name from sources
