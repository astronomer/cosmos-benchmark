{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00312') }}
)
select id, 'model_01116' as name from sources
