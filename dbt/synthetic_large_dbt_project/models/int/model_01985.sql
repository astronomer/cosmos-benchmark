{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01028') }},
        {{ ref('model_01076') }},
        {{ ref('model_01387') }}
)
select id, 'model_01985' as name from sources
