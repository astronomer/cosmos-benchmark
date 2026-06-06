{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00536') }}
)
select id, 'model_01164' as name from sources
