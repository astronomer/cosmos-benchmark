{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01927') }}
)
select id, 'model_02331' as name from sources
