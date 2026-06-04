{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00471') }}
)
select id, 'model_01110' as name from sources
