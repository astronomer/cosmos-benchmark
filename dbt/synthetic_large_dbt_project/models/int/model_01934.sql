{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01231') }}
)
select id, 'model_01934' as name from sources
