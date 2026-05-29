{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00738') }}
)
select id, 'model_01233' as name from sources
