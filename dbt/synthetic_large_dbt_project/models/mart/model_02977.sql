{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02032') }}
)
select id, 'model_02977' as name from sources
