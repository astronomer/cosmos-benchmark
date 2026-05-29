{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02112') }}
)
select id, 'model_02776' as name from sources
