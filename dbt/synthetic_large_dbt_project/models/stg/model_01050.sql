{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00351') }}
)
select id, 'model_01050' as name from sources
