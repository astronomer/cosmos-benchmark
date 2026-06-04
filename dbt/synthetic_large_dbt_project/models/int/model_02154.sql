{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00824') }}
)
select id, 'model_02154' as name from sources
