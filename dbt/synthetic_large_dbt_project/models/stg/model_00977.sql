{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00456') }}
)
select id, 'model_00977' as name from sources
