{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01139') }},
        {{ ref('model_00813') }},
        {{ ref('model_01120') }}
)
select id, 'model_01935' as name from sources
