{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01955') }},
        {{ ref('model_01838') }},
        {{ ref('model_01961') }}
)
select id, 'model_02338' as name from sources
