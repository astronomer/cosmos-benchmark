{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01999') }}
)
select id, 'model_02363' as name from sources
