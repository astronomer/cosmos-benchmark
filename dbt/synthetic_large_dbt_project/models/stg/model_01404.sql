{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00392') }}
)
select id, 'model_01404' as name from sources
