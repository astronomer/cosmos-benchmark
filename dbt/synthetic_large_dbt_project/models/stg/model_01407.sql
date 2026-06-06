{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00582') }}
)
select id, 'model_01407' as name from sources
