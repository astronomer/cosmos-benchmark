{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01786') }}
)
select id, 'model_02378' as name from sources
