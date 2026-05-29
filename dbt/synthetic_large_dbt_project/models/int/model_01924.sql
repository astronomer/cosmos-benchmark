{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01477') }}
)
select id, 'model_01924' as name from sources
