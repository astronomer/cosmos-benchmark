{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01814') }}
)
select id, 'model_02517' as name from sources
