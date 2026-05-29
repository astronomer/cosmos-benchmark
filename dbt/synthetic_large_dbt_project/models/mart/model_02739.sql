{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01627') }},
        {{ ref('model_01597') }}
)
select id, 'model_02739' as name from sources
