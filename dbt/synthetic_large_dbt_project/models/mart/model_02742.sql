{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01918') }}
)
select id, 'model_02742' as name from sources
