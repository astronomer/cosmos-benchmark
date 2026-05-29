{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01793') }}
)
select id, 'model_02801' as name from sources
