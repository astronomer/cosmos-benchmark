{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01712') }},
        {{ ref('model_01746') }}
)
select id, 'model_02941' as name from sources
