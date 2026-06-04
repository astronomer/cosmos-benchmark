{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00061') }},
        {{ ref('model_00264') }}
)
select id, 'model_01267' as name from sources
