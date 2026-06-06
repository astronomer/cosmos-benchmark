{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00387') }}
)
select id, 'model_01165' as name from sources
