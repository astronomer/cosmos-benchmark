{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02182') }},
        {{ ref('model_02248') }},
        {{ ref('model_01814') }}
)
select id, 'model_02948' as name from sources
