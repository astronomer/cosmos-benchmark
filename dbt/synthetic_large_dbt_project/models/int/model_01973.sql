{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01256') }}
)
select id, 'model_01973' as name from sources
