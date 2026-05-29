{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00947') }}
)
select id, 'model_02248' as name from sources
