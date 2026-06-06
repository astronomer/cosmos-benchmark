{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01761') }}
)
select id, 'model_02976' as name from sources
