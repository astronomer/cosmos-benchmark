{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00118') }},
        {{ ref('model_00360') }},
        {{ ref('model_00575') }}
)
select id, 'model_00927' as name from sources
