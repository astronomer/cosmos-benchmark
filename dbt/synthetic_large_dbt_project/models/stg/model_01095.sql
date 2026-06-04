{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00032') }}
)
select id, 'model_01095' as name from sources
