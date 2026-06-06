{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00907') }}
)
select id, 'model_01573' as name from sources
