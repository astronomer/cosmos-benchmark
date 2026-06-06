{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00725') }}
)
select id, 'model_01183' as name from sources
