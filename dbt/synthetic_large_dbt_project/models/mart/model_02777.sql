{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01990') }}
)
select id, 'model_02777' as name from sources
