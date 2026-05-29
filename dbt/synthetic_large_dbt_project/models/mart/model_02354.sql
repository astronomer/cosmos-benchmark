{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02123') }}
)
select id, 'model_02354' as name from sources
