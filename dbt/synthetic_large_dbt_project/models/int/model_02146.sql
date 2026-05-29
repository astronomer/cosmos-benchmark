{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01459') }}
)
select id, 'model_02146' as name from sources
