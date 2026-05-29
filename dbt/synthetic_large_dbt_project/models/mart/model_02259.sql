{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02050') }}
)
select id, 'model_02259' as name from sources
