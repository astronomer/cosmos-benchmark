{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00661') }}
)
select id, 'model_01189' as name from sources
