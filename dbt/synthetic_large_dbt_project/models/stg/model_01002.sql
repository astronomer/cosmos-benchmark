{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00290') }}
)
select id, 'model_01002' as name from sources
