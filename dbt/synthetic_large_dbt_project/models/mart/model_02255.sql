{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01888') }}
)
select id, 'model_02255' as name from sources
