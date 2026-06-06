{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00040') }}
)
select id, 'model_00939' as name from sources
