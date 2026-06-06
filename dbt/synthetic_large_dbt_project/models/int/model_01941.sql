{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01463') }}
)
select id, 'model_01941' as name from sources
