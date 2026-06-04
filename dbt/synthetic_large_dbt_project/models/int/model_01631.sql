{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01040') }}
)
select id, 'model_01631' as name from sources
