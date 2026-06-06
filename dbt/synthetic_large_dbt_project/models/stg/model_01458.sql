{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00580') }}
)
select id, 'model_01458' as name from sources
