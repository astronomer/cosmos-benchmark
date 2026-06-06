{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00266') }}
)
select id, 'model_01470' as name from sources
