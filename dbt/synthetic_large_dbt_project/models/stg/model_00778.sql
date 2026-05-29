{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00728') }}
)
select id, 'model_00778' as name from sources
