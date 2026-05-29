{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01089') }}
)
select id, 'model_01707' as name from sources
