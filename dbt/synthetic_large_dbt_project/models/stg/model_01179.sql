{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00111') }}
)
select id, 'model_01179' as name from sources
