{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00271') }}
)
select id, 'model_01029' as name from sources
