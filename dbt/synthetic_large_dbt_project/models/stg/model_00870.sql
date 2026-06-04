{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00483') }}
)
select id, 'model_00870' as name from sources
