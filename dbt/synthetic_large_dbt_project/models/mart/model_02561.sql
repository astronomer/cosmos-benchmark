{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01566') }}
)
select id, 'model_02561' as name from sources
