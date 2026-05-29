{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01685') }}
)
select id, 'model_02650' as name from sources
