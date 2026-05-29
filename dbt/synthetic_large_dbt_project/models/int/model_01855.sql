{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00919') }}
)
select id, 'model_01855' as name from sources
