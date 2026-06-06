{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00962') }},
        {{ ref('model_01039') }},
        {{ ref('model_01457') }}
)
select id, 'model_01518' as name from sources
