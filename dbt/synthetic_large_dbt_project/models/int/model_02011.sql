{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00967') }}
)
select id, 'model_02011' as name from sources
