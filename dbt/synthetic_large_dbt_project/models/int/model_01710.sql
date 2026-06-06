{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00803') }}
)
select id, 'model_01710' as name from sources
