{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01262') }}
)
select id, 'model_01719' as name from sources
