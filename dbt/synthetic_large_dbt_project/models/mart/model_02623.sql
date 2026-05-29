{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02036') }}
)
select id, 'model_02623' as name from sources
