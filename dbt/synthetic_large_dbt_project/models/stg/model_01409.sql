{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00386') }},
        {{ ref('model_00631') }},
        {{ ref('model_00692') }}
)
select id, 'model_01409' as name from sources
