{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00825') }}
)
select id, 'model_01629' as name from sources
