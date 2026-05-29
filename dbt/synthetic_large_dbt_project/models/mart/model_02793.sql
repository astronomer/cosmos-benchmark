{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01944') }}
)
select id, 'model_02793' as name from sources
