{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01157') }}
)
select id, 'model_01655' as name from sources
