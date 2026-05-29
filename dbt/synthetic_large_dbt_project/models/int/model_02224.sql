{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01348') }},
        {{ ref('model_01496') }}
)
select id, 'model_02224' as name from sources
