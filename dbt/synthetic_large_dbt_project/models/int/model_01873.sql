{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00794') }},
        {{ ref('model_00885') }},
        {{ ref('model_01004') }}
)
select id, 'model_01873' as name from sources
