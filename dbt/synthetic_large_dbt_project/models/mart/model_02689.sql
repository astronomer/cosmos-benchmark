{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02128') }}
)
select id, 'model_02689' as name from sources
