{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00271') }},
        {{ ref('model_00676') }},
        {{ ref('model_00288') }}
)
select id, 'model_00824' as name from sources
