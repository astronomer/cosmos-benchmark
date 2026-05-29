{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01675') }}
)
select id, 'model_02737' as name from sources
