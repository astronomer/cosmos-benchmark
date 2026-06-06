{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01425') }}
)
select id, 'model_02010' as name from sources
