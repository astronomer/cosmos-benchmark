{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02189') }}
)
select id, 'model_02310' as name from sources
