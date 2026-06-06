{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01657') }}
)
select id, 'model_02914' as name from sources
