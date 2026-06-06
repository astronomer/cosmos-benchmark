{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01161') }}
)
select id, 'model_01823' as name from sources
