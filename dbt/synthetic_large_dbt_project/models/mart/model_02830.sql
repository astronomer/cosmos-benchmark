{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01985') }}
)
select id, 'model_02830' as name from sources
