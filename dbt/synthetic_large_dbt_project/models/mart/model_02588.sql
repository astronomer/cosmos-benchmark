{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01551') }}
)
select id, 'model_02588' as name from sources
