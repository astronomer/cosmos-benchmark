{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00321') }}
)
select id, 'model_01388' as name from sources
