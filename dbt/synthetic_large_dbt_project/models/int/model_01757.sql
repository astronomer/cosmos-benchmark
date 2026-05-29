{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01047') }}
)
select id, 'model_01757' as name from sources
