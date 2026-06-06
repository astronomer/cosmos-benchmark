{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01522') }}
)
select id, 'model_02487' as name from sources
