{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01953') }}
)
select id, 'model_02476' as name from sources
