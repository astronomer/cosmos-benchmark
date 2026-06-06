{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00974') }}
)
select id, 'model_01904' as name from sources
