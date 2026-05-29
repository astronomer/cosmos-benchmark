{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00494') }}
)
select id, 'model_01197' as name from sources
