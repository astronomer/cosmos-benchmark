{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02082') }}
)
select id, 'model_02536' as name from sources
