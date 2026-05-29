{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00238') }}
)
select id, 'model_00805' as name from sources
