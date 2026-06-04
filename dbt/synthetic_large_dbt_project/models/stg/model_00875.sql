{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00629') }}
)
select id, 'model_00875' as name from sources
