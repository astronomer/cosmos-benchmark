{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01051') }}
)
select id, 'model_01649' as name from sources
