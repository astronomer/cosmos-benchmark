{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01300') }}
)
select id, 'model_02149' as name from sources
