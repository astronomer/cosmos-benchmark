{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00066') }}
)
select id, 'model_01395' as name from sources
