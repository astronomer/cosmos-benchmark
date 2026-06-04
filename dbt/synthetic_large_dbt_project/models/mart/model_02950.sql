{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01606') }}
)
select id, 'model_02950' as name from sources
