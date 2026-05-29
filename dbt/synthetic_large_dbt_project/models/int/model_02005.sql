{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01020') }}
)
select id, 'model_02005' as name from sources
