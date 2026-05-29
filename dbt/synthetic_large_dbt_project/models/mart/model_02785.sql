{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01542') }}
)
select id, 'model_02785' as name from sources
