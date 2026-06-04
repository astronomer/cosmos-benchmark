{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01575') }}
)
select id, 'model_02380' as name from sources
