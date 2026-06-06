{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01506') }}
)
select id, 'model_02543' as name from sources
