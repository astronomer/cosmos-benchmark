{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00346') }}
)
select id, 'model_00821' as name from sources
