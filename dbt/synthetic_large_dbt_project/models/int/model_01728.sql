{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01187') }}
)
select id, 'model_01728' as name from sources
