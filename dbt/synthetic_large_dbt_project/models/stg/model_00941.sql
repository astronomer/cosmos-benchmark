{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00325') }},
        {{ ref('model_00538') }},
        {{ ref('model_00225') }}
)
select id, 'model_00941' as name from sources
