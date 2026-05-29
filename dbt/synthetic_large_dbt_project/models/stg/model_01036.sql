{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00333') }}
)
select id, 'model_01036' as name from sources
