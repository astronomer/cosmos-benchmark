{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02232') }}
)
select id, 'model_02747' as name from sources
