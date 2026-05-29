{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01075') }}
)
select id, 'model_01577' as name from sources
