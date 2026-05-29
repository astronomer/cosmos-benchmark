{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00505') }}
)
select id, 'model_01073' as name from sources
