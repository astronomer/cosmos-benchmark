{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00863') }}
)
select id, 'model_01669' as name from sources
