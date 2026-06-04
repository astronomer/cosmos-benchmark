{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00151') }}
)
select id, 'model_01337' as name from sources
