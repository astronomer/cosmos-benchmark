{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01811') }},
        {{ ref('model_01838') }},
        {{ ref('model_01738') }}
)
select id, 'model_02491' as name from sources
