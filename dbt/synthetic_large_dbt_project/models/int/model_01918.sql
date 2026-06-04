{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00884') }},
        {{ ref('model_01097') }}
)
select id, 'model_01918' as name from sources
