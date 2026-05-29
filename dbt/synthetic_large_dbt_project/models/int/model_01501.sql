{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00858') }},
        {{ ref('model_01194') }},
        {{ ref('model_01297') }}
)
select id, 'model_01501' as name from sources
