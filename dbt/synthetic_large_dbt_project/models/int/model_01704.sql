{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00905') }}
)
select id, 'model_01704' as name from sources
