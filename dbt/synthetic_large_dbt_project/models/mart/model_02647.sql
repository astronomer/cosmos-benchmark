{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01710') }}
)
select id, 'model_02647' as name from sources
