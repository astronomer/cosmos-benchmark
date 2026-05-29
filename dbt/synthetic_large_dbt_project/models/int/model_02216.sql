{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01027') }},
        {{ ref('model_01285') }},
        {{ ref('model_01080') }}
)
select id, 'model_02216' as name from sources
