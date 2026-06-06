{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('seed_dim') }}
)
select id, 'model_00417' as name from sources
