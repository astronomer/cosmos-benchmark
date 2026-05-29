{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01886') }}
)
select id, 'model_02783' as name from sources
