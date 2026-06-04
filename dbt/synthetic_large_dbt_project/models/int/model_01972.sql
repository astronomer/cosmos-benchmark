{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00859') }}
)
select id, 'model_01972' as name from sources
