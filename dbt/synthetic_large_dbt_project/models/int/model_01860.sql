{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01407') }}
)
select id, 'model_01860' as name from sources
