{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01186') }}
)
select id, 'model_01870' as name from sources
