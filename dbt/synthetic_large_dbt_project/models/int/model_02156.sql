{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01094') }}
)
select id, 'model_02156' as name from sources
