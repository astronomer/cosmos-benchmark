{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00310') }}
)
select id, 'model_01401' as name from sources
