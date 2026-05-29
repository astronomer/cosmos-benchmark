{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02061') }}
)
select id, 'model_02635' as name from sources
