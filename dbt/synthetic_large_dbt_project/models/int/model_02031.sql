{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00767') }}
)
select id, 'model_02031' as name from sources
