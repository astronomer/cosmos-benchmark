{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01396') }}
)
select id, 'model_01820' as name from sources
