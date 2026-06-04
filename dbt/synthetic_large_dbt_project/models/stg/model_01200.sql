{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00004') }}
)
select id, 'model_01200' as name from sources
