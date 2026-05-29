{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00526') }},
        {{ ref('model_00122') }},
        {{ ref('model_00386') }}
)
select id, 'model_00937' as name from sources
