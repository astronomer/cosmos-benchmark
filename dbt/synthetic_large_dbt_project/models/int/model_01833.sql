{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01450') }}
)
select id, 'model_01833' as name from sources
