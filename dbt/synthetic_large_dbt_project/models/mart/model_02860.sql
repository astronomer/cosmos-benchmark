{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02037') }}
)
select id, 'model_02860' as name from sources
