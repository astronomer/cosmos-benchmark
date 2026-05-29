{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00089') }}
)
select id, 'model_00837' as name from sources
