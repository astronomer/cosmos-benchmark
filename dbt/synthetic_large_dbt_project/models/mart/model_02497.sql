{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01598') }}
)
select id, 'model_02497' as name from sources
