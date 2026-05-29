{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01640') }}
)
select id, 'model_02638' as name from sources
