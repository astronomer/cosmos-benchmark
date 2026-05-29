{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00913') }},
        {{ ref('model_00772') }},
        {{ ref('model_01311') }}
)
select id, 'model_01767' as name from sources
