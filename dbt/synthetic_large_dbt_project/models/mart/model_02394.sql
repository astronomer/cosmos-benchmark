{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01508') }}
)
select id, 'model_02394' as name from sources
