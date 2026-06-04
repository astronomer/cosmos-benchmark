{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00566') }}
)
select id, 'model_00769' as name from sources
