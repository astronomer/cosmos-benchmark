{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02182') }}
)
select id, 'model_02582' as name from sources
