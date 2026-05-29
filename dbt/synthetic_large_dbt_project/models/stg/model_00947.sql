{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00526') }},
        {{ ref('model_00520') }}
)
select id, 'model_00947' as name from sources
