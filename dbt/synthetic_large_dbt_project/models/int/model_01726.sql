{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00762') }}
)
select id, 'model_01726' as name from sources
