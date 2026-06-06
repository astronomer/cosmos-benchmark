{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01853') }}
)
select id, 'model_02503' as name from sources
