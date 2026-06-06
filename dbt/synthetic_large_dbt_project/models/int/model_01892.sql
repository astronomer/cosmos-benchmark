{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01121') }}
)
select id, 'model_01892' as name from sources
