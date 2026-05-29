{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01120') }}
)
select id, 'model_01527' as name from sources
