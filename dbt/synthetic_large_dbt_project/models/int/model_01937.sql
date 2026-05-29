{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00820') }}
)
select id, 'model_01937' as name from sources
