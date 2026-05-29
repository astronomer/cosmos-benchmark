{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01161') }}
)
select id, 'model_01695' as name from sources
