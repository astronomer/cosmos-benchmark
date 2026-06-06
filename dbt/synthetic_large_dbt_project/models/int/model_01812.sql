{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01339') }}
)
select id, 'model_01812' as name from sources
