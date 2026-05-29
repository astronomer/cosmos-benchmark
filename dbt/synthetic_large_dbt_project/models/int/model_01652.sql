{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01031') }},
        {{ ref('model_00945') }},
        {{ ref('model_01472') }}
)
select id, 'model_01652' as name from sources
