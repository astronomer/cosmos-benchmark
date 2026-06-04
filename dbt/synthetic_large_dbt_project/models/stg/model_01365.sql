{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00365') }}
)
select id, 'model_01365' as name from sources
