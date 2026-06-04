{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01524') }}
)
select id, 'model_02679' as name from sources
