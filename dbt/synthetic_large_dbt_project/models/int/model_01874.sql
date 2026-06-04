{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00759') }}
)
select id, 'model_01874' as name from sources
