{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00918') }}
)
select id, 'model_02219' as name from sources
