{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00487') }}
)
select id, 'model_01392' as name from sources
