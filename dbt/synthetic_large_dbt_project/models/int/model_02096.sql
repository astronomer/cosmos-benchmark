{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01019') }},
        {{ ref('model_01418') }}
)
select id, 'model_02096' as name from sources
