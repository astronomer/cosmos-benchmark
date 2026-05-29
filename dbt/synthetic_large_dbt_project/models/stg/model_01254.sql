{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00545') }},
        {{ ref('model_00239') }},
        {{ ref('model_00388') }}
)
select id, 'model_01254' as name from sources
