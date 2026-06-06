{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00341') }}
)
select id, 'model_01201' as name from sources
