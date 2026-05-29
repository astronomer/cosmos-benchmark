{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01036') }}
)
select id, 'model_02226' as name from sources
