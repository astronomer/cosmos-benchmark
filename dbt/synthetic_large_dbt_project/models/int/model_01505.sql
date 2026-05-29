{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01462') }}
)
select id, 'model_01505' as name from sources
