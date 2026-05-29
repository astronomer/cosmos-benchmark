{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00770') }}
)
select id, 'model_01593' as name from sources
