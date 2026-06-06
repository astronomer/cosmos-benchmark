{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01714') }}
)
select id, 'model_02466' as name from sources
