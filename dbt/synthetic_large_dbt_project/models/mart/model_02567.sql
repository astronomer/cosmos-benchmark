{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01755') }},
        {{ ref('model_01616') }},
        {{ ref('model_02179') }}
)
select id, 'model_02567' as name from sources
