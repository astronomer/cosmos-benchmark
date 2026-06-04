{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01314') }}
)
select id, 'model_02100' as name from sources
