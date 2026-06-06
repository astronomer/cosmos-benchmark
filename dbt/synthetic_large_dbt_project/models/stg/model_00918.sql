{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00648') }}
)
select id, 'model_00918' as name from sources
