{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00591') }}
)
select id, 'model_01252' as name from sources
