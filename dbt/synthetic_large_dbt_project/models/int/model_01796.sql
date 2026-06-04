{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01461') }},
        {{ ref('model_00896') }}
)
select id, 'model_01796' as name from sources
