{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00916') }},
        {{ ref('model_00931') }}
)
select id, 'model_01869' as name from sources
