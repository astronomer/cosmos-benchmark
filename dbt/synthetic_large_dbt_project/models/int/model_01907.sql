{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00829') }}
)
select id, 'model_01907' as name from sources
