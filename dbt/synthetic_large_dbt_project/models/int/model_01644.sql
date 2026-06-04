{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01063') }}
)
select id, 'model_01644' as name from sources
