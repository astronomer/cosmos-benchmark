{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01747') }}
)
select id, 'model_02534' as name from sources
