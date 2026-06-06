{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00721') }}
)
select id, 'model_01206' as name from sources
