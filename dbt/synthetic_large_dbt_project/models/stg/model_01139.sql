{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00568') }}
)
select id, 'model_01139' as name from sources
