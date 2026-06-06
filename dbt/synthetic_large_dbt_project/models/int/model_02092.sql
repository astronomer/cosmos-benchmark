{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01365') }}
)
select id, 'model_02092' as name from sources
