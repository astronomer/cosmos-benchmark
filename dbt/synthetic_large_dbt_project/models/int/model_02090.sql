{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01199') }}
)
select id, 'model_02090' as name from sources
