{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00655') }}
)
select id, 'model_01014' as name from sources
