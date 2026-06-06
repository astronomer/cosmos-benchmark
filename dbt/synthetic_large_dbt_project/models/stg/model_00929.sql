{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00390') }}
)
select id, 'model_00929' as name from sources
