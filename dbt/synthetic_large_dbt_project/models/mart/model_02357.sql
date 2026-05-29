{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01989') }}
)
select id, 'model_02357' as name from sources
