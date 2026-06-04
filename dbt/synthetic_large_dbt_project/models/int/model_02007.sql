{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01348') }}
)
select id, 'model_02007' as name from sources
