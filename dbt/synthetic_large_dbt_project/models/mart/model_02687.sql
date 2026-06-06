{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01965') }}
)
select id, 'model_02687' as name from sources
