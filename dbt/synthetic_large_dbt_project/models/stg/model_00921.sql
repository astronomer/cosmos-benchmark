{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00106') }}
)
select id, 'model_00921' as name from sources
