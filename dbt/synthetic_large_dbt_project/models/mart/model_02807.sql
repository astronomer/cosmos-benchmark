{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01696') }}
)
select id, 'model_02807' as name from sources
