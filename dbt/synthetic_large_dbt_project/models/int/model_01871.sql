{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01491') }}
)
select id, 'model_01871' as name from sources
