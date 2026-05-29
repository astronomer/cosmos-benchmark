{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00681') }},
        {{ ref('model_00713') }},
        {{ ref('model_00542') }}
)
select id, 'model_01335' as name from sources
