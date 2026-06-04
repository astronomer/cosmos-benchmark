{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00971') }}
)
select id, 'model_01687' as name from sources
