{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02070') }},
        {{ ref('model_02218') }}
)
select id, 'model_02699' as name from sources
