{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00871') }}
)
select id, 'model_01776' as name from sources
