{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01418') }}
)
select id, 'model_01777' as name from sources
