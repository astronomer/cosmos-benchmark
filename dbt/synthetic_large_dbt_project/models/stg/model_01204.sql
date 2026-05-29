{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00279') }}
)
select id, 'model_01204' as name from sources
