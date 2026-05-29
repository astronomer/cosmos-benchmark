{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00745') }}
)
select id, 'model_01053' as name from sources
