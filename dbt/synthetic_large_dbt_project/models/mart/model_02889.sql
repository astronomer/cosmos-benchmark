{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01879') }},
        {{ ref('model_02034') }},
        {{ ref('model_01760') }}
)
select id, 'model_02889' as name from sources
