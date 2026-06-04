{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00504') }}
)
select id, 'model_00804' as name from sources
