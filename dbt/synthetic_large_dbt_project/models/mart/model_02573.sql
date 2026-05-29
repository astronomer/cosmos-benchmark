{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01863') }}
)
select id, 'model_02573' as name from sources
