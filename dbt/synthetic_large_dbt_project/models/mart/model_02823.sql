{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01543') }}
)
select id, 'model_02823' as name from sources
