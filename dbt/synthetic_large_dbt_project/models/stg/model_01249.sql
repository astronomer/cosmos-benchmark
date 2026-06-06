{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00267') }}
)
select id, 'model_01249' as name from sources
