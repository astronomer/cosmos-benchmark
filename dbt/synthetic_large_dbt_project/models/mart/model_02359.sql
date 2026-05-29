{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02237') }}
)
select id, 'model_02359' as name from sources
