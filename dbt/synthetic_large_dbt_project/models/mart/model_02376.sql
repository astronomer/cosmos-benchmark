{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01748') }}
)
select id, 'model_02376' as name from sources
