{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00690') }}
)
select id, 'model_01016' as name from sources
