{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01366') }},
        {{ ref('model_01354') }},
        {{ ref('model_00977') }}
)
select id, 'model_01761' as name from sources
