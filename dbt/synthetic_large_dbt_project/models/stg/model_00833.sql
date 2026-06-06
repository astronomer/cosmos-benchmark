{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00404') }}
)
select id, 'model_00833' as name from sources
