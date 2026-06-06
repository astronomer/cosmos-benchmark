{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01603') }}
)
select id, 'model_02397' as name from sources
