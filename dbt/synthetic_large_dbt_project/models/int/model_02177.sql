{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01258') }}
)
select id, 'model_02177' as name from sources
