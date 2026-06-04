{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00677') }}
)
select id, 'model_00884' as name from sources
