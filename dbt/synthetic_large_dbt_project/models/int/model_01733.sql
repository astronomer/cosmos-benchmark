{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00952') }}
)
select id, 'model_01733' as name from sources
