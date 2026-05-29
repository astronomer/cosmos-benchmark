{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01547') }}
)
select id, 'model_02877' as name from sources
