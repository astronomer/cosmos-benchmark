{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01257') }}
)
select id, 'model_01626' as name from sources
