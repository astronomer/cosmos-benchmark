{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01064') }}
)
select id, 'model_02127' as name from sources
