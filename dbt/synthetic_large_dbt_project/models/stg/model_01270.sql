{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00072') }}
)
select id, 'model_01270' as name from sources
