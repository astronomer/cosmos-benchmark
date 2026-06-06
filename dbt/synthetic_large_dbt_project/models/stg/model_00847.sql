{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00416') }}
)
select id, 'model_00847' as name from sources
