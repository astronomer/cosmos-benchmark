{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00481') }}
)
select id, 'model_00869' as name from sources
