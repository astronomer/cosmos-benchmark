{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00041') }}
)
select id, 'model_01491' as name from sources
