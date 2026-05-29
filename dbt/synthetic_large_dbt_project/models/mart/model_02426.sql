{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01835') }}
)
select id, 'model_02426' as name from sources
