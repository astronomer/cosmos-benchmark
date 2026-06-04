{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00587') }}
)
select id, 'model_00792' as name from sources
