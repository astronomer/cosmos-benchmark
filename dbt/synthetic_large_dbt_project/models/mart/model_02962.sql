{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02107') }}
)
select id, 'model_02962' as name from sources
