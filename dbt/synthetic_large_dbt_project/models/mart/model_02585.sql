{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01572') }},
        {{ ref('model_01659') }},
        {{ ref('model_02096') }}
)
select id, 'model_02585' as name from sources
