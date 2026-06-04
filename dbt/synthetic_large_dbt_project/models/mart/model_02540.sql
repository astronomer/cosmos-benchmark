{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02116') }}
)
select id, 'model_02540' as name from sources
