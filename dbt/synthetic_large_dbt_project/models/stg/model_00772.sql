{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00476') }}
)
select id, 'model_00772' as name from sources
