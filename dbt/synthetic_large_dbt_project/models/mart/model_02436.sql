{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01907') }}
)
select id, 'model_02436' as name from sources
