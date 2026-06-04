{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00749') }}
)
select id, 'model_00978' as name from sources
