{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01116') }}
)
select id, 'model_01989' as name from sources
