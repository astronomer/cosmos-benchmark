{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01403') }}
)
select id, 'model_01971' as name from sources
