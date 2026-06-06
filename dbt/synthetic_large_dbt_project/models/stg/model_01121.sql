{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00492') }}
)
select id, 'model_01121' as name from sources
