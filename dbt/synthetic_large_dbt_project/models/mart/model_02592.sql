{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02219') }}
)
select id, 'model_02592' as name from sources
