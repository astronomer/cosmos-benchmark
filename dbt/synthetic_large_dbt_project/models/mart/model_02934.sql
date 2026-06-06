{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01654') }}
)
select id, 'model_02934' as name from sources
