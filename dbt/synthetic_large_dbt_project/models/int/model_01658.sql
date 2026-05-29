{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00964') }},
        {{ ref('model_01199') }}
)
select id, 'model_01658' as name from sources
