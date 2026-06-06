{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01107') }}
)
select id, 'model_01893' as name from sources
