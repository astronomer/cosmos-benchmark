{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00282') }}
)
select id, 'model_01330' as name from sources
