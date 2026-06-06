{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01756') }}
)
select id, 'model_02424' as name from sources
