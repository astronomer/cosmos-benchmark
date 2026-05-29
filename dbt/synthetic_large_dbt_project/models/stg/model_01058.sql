{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00539') }}
)
select id, 'model_01058' as name from sources
