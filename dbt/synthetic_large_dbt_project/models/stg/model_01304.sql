{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00242') }}
)
select id, 'model_01304' as name from sources
