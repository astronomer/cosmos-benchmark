{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00380') }}
)
select id, 'model_01195' as name from sources
