{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00793') }},
        {{ ref('model_01385') }},
        {{ ref('model_01409') }}
)
select id, 'model_01928' as name from sources
