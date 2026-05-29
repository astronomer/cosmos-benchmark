{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00133') }}
)
select id, 'model_00789' as name from sources
