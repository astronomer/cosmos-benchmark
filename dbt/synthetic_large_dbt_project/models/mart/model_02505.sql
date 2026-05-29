{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02137') }}
)
select id, 'model_02505' as name from sources
