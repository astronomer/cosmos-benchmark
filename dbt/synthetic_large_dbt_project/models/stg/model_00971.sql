{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00551') }}
)
select id, 'model_00971' as name from sources
