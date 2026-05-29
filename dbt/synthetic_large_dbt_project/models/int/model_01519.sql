{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01370') }}
)
select id, 'model_01519' as name from sources
