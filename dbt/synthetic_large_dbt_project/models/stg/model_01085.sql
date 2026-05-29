{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00128') }}
)
select id, 'model_01085' as name from sources
