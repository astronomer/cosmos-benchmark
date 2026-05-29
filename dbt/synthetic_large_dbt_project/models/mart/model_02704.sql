{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01636') }},
        {{ ref('model_02218') }}
)
select id, 'model_02704' as name from sources
