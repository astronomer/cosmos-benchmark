{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00729') }}
)
select id, 'model_00968' as name from sources
