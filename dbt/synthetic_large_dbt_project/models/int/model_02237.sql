{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01141') }}
)
select id, 'model_02237' as name from sources
