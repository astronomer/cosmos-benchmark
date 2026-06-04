{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01971') }}
)
select id, 'model_02486' as name from sources
