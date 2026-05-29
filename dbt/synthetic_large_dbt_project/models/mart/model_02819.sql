{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01758') }}
)
select id, 'model_02819' as name from sources
