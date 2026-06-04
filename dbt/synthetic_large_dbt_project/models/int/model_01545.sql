{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01209') }}
)
select id, 'model_01545' as name from sources
