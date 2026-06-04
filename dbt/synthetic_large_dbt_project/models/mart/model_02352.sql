{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01957') }}
)
select id, 'model_02352' as name from sources
