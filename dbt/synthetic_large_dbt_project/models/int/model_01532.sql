{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00891') }}
)
select id, 'model_01532' as name from sources
