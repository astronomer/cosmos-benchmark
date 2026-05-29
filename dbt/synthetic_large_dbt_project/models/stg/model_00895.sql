{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00009') }}
)
select id, 'model_00895' as name from sources
