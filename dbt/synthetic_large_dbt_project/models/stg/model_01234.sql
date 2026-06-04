{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00140') }}
)
select id, 'model_01234' as name from sources
