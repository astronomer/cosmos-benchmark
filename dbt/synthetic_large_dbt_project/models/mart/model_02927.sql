{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02197') }}
)
select id, 'model_02927' as name from sources
