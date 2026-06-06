{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01609') }}
)
select id, 'model_02583' as name from sources
