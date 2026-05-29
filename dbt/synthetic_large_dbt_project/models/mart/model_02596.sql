{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02005') }}
)
select id, 'model_02596' as name from sources
