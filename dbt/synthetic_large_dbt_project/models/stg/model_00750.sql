{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00291') }},
        {{ ref('model_00707') }},
        {{ ref('model_00027') }}
)
select id, 'model_00750' as name from sources
