{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00538') }}
)
select id, 'model_00808' as name from sources
