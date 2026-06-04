{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00622') }}
)
select id, 'model_01154' as name from sources
