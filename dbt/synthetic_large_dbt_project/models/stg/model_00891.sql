{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00113') }}
)
select id, 'model_00891' as name from sources
