{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01538') }}
)
select id, 'model_02660' as name from sources
