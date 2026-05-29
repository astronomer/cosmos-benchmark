{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00652') }}
)
select id, 'model_00780' as name from sources
