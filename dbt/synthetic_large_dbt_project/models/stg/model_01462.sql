{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00297') }}
)
select id, 'model_01462' as name from sources
