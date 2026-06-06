{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02180') }}
)
select id, 'model_02852' as name from sources
