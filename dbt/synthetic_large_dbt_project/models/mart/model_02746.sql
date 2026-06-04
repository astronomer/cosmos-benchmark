{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01913') }}
)
select id, 'model_02746' as name from sources
