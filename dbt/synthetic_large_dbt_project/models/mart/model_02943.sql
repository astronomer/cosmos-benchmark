{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01625') }}
)
select id, 'model_02943' as name from sources
