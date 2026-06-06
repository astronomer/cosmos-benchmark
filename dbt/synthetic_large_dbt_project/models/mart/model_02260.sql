{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02198') }},
        {{ ref('model_01795') }},
        {{ ref('model_01712') }}
)
select id, 'model_02260' as name from sources
