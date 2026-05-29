{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00108') }}
)
select id, 'model_01208' as name from sources
