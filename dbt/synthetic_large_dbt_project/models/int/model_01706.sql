{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01283') }}
)
select id, 'model_01706' as name from sources
