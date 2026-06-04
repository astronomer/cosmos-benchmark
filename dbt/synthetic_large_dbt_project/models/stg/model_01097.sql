{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00013') }}
)
select id, 'model_01097' as name from sources
