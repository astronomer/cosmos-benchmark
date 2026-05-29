{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01809') }},
        {{ ref('model_01932') }},
        {{ ref('model_01910') }}
)
select id, 'model_02300' as name from sources
