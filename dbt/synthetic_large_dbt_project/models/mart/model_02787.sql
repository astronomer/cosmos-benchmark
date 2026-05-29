{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01500') }}
)
select id, 'model_02787' as name from sources
