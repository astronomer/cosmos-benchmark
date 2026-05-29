{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00935') }},
        {{ ref('model_00777') }}
)
select id, 'model_01574' as name from sources
