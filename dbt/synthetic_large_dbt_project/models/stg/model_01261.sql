{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00742') }}
)
select id, 'model_01261' as name from sources
