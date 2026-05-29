{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00547') }}
)
select id, 'model_01369' as name from sources
