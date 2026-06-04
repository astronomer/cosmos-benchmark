{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00183') }}
)
select id, 'model_00771' as name from sources
