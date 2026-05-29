{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02096') }}
)
select id, 'model_02862' as name from sources
