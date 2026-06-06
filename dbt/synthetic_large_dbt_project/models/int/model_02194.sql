{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01316') }}
)
select id, 'model_02194' as name from sources
