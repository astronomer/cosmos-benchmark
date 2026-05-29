{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02108') }}
)
select id, 'model_02626' as name from sources
