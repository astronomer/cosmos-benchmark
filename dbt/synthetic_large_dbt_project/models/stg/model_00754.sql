{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00482') }}
)
select id, 'model_00754' as name from sources
