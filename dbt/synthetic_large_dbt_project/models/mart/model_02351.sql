{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01568') }},
        {{ ref('model_01777') }},
        {{ ref('model_02066') }}
)
select id, 'model_02351' as name from sources
