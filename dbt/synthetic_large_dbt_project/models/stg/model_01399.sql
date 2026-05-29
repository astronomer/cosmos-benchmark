{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00501') }},
        {{ ref('model_00509') }}
)
select id, 'model_01399' as name from sources
