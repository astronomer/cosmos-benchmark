{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00647') }}
)
select id, 'model_01275' as name from sources
