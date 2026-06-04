{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00874') }}
)
select id, 'model_02060' as name from sources
