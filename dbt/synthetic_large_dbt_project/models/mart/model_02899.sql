{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01736') }}
)
select id, 'model_02899' as name from sources
