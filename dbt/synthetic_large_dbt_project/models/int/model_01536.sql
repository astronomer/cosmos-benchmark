{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00809') }},
        {{ ref('model_01396') }},
        {{ ref('model_01480') }}
)
select id, 'model_01536' as name from sources
