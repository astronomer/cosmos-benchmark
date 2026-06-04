{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00217') }},
        {{ ref('model_00011') }},
        {{ ref('model_00655') }}
)
select id, 'model_01185' as name from sources
