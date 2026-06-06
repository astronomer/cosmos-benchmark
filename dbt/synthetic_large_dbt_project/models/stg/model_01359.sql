{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00157') }}
)
select id, 'model_01359' as name from sources
