{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01183') }}
)
select id, 'model_01789' as name from sources
