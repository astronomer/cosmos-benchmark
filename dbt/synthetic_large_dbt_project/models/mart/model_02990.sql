{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02019') }}
)
select id, 'model_02990' as name from sources
