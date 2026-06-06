{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01987') }}
)
select id, 'model_02418' as name from sources
