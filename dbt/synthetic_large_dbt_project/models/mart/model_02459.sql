{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02089') }}
)
select id, 'model_02459' as name from sources
