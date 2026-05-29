{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00966') }}
)
select id, 'model_01500' as name from sources
