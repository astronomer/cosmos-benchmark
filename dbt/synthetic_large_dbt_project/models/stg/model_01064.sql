{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00704') }}
)
select id, 'model_01064' as name from sources
