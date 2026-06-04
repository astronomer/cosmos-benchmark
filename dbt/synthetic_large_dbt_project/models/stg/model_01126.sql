{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00204') }}
)
select id, 'model_01126' as name from sources
