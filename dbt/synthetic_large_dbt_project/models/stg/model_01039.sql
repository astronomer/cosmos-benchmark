{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00585') }}
)
select id, 'model_01039' as name from sources
