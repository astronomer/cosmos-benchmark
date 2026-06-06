{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01479') }}
)
select id, 'model_01919' as name from sources
