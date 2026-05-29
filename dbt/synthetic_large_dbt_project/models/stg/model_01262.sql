{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00058') }}
)
select id, 'model_01262' as name from sources
