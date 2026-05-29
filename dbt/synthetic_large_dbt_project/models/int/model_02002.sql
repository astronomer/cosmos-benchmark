{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00892') }}
)
select id, 'model_02002' as name from sources
