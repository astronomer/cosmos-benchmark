{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00268') }}
)
select id, 'model_01056' as name from sources
