{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01152') }}
)
select id, 'model_01535' as name from sources
