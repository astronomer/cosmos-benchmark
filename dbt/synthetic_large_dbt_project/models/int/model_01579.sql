{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01002') }}
)
select id, 'model_01579' as name from sources
