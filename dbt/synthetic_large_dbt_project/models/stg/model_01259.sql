{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00320') }}
)
select id, 'model_01259' as name from sources
