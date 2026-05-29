{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00730') }}
)
select id, 'model_01210' as name from sources
