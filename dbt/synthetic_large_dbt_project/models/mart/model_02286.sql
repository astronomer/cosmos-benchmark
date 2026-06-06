{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01664') }}
)
select id, 'model_02286' as name from sources
