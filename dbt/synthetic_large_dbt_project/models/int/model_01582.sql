{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01385') }},
        {{ ref('model_01046') }}
)
select id, 'model_01582' as name from sources
