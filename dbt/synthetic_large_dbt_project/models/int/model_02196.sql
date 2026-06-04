{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01396') }}
)
select id, 'model_02196' as name from sources
