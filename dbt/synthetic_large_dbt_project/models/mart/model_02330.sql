{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02198') }}
)
select id, 'model_02330' as name from sources
