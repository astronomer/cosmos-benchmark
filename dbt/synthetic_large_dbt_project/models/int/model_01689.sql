{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01149') }}
)
select id, 'model_01689' as name from sources
