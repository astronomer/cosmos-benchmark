{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01398') }}
)
select id, 'model_01746' as name from sources
