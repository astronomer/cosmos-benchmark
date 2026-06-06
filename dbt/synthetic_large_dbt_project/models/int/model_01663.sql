{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01337') }},
        {{ ref('model_01150') }},
        {{ ref('model_01140') }}
)
select id, 'model_01663' as name from sources
