{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00064') }}
)
select id, 'model_00979' as name from sources
