{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01404') }}
)
select id, 'model_01681' as name from sources
