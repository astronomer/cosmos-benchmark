{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00792') }}
)
select id, 'model_02163' as name from sources
