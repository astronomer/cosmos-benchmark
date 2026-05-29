{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00942') }},
        {{ ref('model_00954') }},
        {{ ref('model_01460') }}
)
select id, 'model_02221' as name from sources
