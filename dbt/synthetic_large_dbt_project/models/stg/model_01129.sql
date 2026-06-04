{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00550') }}
)
select id, 'model_01129' as name from sources
