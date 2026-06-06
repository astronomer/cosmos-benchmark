{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01655') }}
)
select id, 'model_02565' as name from sources
