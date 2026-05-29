{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00421') }}
)
select id, 'model_01260' as name from sources
