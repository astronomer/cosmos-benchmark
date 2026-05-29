{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00981') }}
)
select id, 'model_01801' as name from sources
