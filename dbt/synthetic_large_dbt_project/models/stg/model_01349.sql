{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00524') }}
)
select id, 'model_01349' as name from sources
