{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00233') }},
        {{ ref('model_00264') }},
        {{ ref('model_00417') }}
)
select id, 'model_00953' as name from sources
