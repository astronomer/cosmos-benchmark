{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01633') }}
)
select id, 'model_02271' as name from sources
