{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00006') }},
        {{ ref('model_00554') }},
        {{ ref('model_00043') }}
)
select id, 'model_01031' as name from sources
