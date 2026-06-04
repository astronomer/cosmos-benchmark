{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01322') }}
)
select id, 'model_01612' as name from sources
