{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00872') }}
)
select id, 'model_01779' as name from sources
