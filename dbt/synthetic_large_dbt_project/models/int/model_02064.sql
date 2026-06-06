{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01282') }}
)
select id, 'model_02064' as name from sources
