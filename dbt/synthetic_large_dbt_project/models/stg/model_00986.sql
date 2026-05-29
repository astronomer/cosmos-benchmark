{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00153') }}
)
select id, 'model_00986' as name from sources
