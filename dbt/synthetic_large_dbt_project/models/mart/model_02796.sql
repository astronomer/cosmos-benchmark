{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01975') }}
)
select id, 'model_02796' as name from sources
