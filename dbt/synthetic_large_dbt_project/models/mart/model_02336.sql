{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01994') }}
)
select id, 'model_02336' as name from sources
