{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01870') }}
)
select id, 'model_02937' as name from sources
