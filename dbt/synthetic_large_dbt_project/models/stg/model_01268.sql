{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00624') }}
)
select id, 'model_01268' as name from sources
