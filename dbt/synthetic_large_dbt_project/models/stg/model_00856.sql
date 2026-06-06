{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00229') }}
)
select id, 'model_00856' as name from sources
