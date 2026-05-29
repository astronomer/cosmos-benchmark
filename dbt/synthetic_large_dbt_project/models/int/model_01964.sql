{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00912') }},
        {{ ref('model_01197') }},
        {{ ref('model_00986') }}
)
select id, 'model_01964' as name from sources
