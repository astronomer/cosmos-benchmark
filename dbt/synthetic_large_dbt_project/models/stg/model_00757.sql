{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00284') }}
)
select id, 'model_00757' as name from sources
