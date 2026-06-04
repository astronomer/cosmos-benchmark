{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01947') }}
)
select id, 'model_02274' as name from sources
