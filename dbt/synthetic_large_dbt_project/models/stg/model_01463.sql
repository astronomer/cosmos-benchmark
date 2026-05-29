{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00596') }},
        {{ ref('model_00700') }}
)
select id, 'model_01463' as name from sources
