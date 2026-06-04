{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00065') }},
        {{ ref('model_00344') }}
)
select id, 'model_00860' as name from sources
