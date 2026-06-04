{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01305') }}
)
select id, 'model_01952' as name from sources
