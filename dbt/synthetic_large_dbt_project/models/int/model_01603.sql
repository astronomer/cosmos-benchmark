{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01488') }}
)
select id, 'model_01603' as name from sources
