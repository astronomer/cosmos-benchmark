{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01283') }}
)
select id, 'model_02114' as name from sources
