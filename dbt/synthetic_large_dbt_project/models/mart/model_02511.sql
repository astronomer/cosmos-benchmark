{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02175') }},
        {{ ref('model_02224') }}
)
select id, 'model_02511' as name from sources
