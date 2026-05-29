{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00167') }}
)
select id, 'model_00762' as name from sources
