{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01040') }}
)
select id, 'model_02071' as name from sources
