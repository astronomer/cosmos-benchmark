{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00693') }}
)
select id, 'model_01025' as name from sources
