{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00124') }},
        {{ ref('model_00547') }},
        {{ ref('model_00242') }}
)
select id, 'model_01444' as name from sources
