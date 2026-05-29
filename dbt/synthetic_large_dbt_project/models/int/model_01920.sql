{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00906') }}
)
select id, 'model_01920' as name from sources
