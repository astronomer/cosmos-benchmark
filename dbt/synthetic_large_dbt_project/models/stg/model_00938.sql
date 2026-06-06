{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00598') }}
)
select id, 'model_00938' as name from sources
