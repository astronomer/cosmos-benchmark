{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01400') }}
)
select id, 'model_01688' as name from sources
