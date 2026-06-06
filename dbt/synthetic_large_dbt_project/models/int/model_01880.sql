{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01253') }}
)
select id, 'model_01880' as name from sources
