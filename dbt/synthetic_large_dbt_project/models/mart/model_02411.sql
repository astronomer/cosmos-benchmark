{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02110') }}
)
select id, 'model_02411' as name from sources
