{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01943') }}
)
select id, 'model_02714' as name from sources
