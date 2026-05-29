{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00037') }}
)
select id, 'model_00973' as name from sources
