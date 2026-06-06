{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01000') }}
)
select id, 'model_02037' as name from sources
