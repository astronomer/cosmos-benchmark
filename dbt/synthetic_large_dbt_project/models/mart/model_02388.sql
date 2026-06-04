{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02016') }}
)
select id, 'model_02388' as name from sources
