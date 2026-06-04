{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00519') }}
)
select id, 'model_00907' as name from sources
