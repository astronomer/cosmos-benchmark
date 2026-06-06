{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01192') }}
)
select id, 'model_02048' as name from sources
