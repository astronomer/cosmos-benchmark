{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01924') }}
)
select id, 'model_02799' as name from sources
