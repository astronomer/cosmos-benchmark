{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00241') }}
)
select id, 'model_01435' as name from sources
