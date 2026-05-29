{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02046') }}
)
select id, 'model_02759' as name from sources
