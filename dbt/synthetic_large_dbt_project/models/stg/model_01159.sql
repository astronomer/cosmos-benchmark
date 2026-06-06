{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00706') }}
)
select id, 'model_01159' as name from sources
