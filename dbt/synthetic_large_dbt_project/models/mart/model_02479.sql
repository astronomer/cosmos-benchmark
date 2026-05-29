{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02126') }}
)
select id, 'model_02479' as name from sources
