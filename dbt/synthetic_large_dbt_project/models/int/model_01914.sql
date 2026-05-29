{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01264') }}
)
select id, 'model_01914' as name from sources
