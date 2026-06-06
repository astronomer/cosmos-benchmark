{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01827') }}
)
select id, 'model_02482' as name from sources
