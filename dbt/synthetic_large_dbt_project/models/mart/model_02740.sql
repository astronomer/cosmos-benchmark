{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01677') }}
)
select id, 'model_02740' as name from sources
