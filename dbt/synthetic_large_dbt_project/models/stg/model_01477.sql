{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00208') }}
)
select id, 'model_01477' as name from sources
