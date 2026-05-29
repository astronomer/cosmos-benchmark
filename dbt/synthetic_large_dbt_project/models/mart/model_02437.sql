{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01703') }}
)
select id, 'model_02437' as name from sources
