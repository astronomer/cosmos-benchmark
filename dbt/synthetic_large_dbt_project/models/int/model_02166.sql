{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01432') }}
)
select id, 'model_02166' as name from sources
