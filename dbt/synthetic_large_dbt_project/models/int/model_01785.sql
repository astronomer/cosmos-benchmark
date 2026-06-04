{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00962') }}
)
select id, 'model_01785' as name from sources
