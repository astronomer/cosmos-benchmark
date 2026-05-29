{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01987') }}
)
select id, 'model_02731' as name from sources
