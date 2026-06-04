{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01515') }}
)
select id, 'model_02417' as name from sources
