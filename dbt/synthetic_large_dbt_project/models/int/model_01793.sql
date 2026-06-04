{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00887') }}
)
select id, 'model_01793' as name from sources
