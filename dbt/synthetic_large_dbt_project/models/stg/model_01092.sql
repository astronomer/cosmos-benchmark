{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00551') }},
        {{ ref('model_00396') }},
        {{ ref('model_00194') }}
)
select id, 'model_01092' as name from sources
