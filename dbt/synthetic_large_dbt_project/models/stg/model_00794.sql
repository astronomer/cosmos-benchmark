{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00035') }}
)
select id, 'model_00794' as name from sources
