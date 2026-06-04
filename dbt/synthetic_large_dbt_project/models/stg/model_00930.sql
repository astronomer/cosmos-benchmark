{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00293') }}
)
select id, 'model_00930' as name from sources
