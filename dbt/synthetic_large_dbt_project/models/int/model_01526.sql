{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01325') }}
)
select id, 'model_01526' as name from sources
