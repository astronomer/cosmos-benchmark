{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01091') }}
)
select id, 'model_01608' as name from sources
