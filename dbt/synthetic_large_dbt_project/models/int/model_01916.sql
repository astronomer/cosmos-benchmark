{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01485') }}
)
select id, 'model_01916' as name from sources
