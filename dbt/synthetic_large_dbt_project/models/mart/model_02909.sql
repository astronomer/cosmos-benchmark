{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01683') }}
)
select id, 'model_02909' as name from sources
