{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00841') }}
)
select id, 'model_02038' as name from sources
