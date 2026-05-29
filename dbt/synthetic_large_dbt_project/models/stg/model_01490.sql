{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00432') }}
)
select id, 'model_01490' as name from sources
