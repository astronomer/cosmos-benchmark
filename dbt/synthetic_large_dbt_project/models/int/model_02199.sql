{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00765') }}
)
select id, 'model_02199' as name from sources
