{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01777') }}
)
select id, 'model_02605' as name from sources
