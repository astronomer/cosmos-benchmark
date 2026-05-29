{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01858') }}
)
select id, 'model_02537' as name from sources
