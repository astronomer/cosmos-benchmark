{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01359') }}
)
select id, 'model_01616' as name from sources
