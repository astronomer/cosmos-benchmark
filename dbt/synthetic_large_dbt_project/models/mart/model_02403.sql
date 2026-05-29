{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02104') }},
        {{ ref('model_01627') }}
)
select id, 'model_02403' as name from sources
