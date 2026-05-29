{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01679') }}
)
select id, 'model_02326' as name from sources
