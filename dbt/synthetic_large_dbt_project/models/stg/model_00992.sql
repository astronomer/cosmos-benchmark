{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00221') }}
)
select id, 'model_00992' as name from sources
