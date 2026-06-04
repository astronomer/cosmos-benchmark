{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02247') }},
        {{ ref('model_01692') }},
        {{ ref('model_02004') }}
)
select id, 'model_02871' as name from sources
