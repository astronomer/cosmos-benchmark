{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02084') }}
)
select id, 'model_02316' as name from sources
