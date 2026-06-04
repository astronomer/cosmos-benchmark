{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00084') }},
        {{ ref('model_00113') }},
        {{ ref('model_00161') }}
)
select id, 'model_01451' as name from sources
