{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01229') }}
)
select id, 'model_02073' as name from sources
