{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00569') }}
)
select id, 'model_01473' as name from sources
