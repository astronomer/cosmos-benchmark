{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01627') }},
        {{ ref('model_01554') }},
        {{ ref('model_01604') }}
)
select id, 'model_02989' as name from sources
