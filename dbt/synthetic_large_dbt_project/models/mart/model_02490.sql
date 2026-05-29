{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01905') }}
)
select id, 'model_02490' as name from sources
