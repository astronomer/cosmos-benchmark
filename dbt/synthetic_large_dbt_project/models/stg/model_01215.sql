{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00174') }},
        {{ ref('model_00289') }}
)
select id, 'model_01215' as name from sources
