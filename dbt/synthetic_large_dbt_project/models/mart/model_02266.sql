{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01949') }}
)
select id, 'model_02266' as name from sources
