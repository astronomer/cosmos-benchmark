{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00946') }}
)
select id, 'model_01851' as name from sources
