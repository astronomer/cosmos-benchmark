{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01734') }}
)
select id, 'model_02755' as name from sources
