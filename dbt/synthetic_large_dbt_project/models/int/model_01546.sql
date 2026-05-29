{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01345') }}
)
select id, 'model_01546' as name from sources
