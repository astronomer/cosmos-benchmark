{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00513') }}
)
select id, 'model_01138' as name from sources
