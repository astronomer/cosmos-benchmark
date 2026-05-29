{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01894') }}
)
select id, 'model_02427' as name from sources
