{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00565') }},
        {{ ref('model_00393') }}
)
select id, 'model_01443' as name from sources
