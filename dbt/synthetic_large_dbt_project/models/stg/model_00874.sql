{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00590') }}
)
select id, 'model_00874' as name from sources
