{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01822') }}
)
select id, 'model_02853' as name from sources
