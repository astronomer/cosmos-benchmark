{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00992') }}
)
select id, 'model_01792' as name from sources
