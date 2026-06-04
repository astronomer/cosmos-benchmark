{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01474') }}
)
select id, 'model_01565' as name from sources
