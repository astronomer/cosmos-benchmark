{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01627') }},
        {{ ref('model_01885') }}
)
select id, 'model_02728' as name from sources
