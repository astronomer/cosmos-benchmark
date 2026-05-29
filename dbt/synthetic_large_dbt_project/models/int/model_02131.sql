{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01014') }}
)
select id, 'model_02131' as name from sources
