{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01436') }}
)
select id, 'model_01564' as name from sources
