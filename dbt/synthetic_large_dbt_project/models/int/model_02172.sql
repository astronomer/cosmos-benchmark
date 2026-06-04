{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01494') }}
)
select id, 'model_02172' as name from sources
