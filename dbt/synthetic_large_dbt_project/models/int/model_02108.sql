{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00879') }}
)
select id, 'model_02108' as name from sources
