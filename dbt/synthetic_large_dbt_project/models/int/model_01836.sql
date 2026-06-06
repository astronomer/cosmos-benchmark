{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01019') }}
)
select id, 'model_01836' as name from sources
