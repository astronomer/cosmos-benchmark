{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00610') }}
)
select id, 'model_01295' as name from sources
