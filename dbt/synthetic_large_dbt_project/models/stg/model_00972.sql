{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00077') }},
        {{ ref('model_00019') }},
        {{ ref('model_00519') }}
)
select id, 'model_00972' as name from sources
