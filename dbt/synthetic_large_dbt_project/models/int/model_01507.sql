{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01235') }}
)
select id, 'model_01507' as name from sources
