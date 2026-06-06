{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00197') }}
)
select id, 'model_00835' as name from sources
