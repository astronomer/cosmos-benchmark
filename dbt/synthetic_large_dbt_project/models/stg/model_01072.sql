{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00732') }}
)
select id, 'model_01072' as name from sources
