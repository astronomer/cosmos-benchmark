{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00028') }}
)
select id, 'model_01430' as name from sources
