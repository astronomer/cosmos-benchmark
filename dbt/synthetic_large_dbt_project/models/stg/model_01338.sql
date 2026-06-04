{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00728') }}
)
select id, 'model_01338' as name from sources
